class ConvertToJpegJob < ApplicationJob
  queue_as :default

  def perform(record, attachment_name)
    attachment = record.send(attachment_name)
    return unless attachment.attached?

    # 一時ファイルにダウンロード
    tempfile = Tempfile.new([attachment.filename.base, attachment.filename.extension_with_delimiter])
    tempfile.binmode
    tempfile.write(attachment.download)
    tempfile.rewind

    # VipsでJPEGに変換
    processed_image = ImageProcessing::Vips
                      .source(tempfile.path)
                      .convert('jpeg')
                      .call

    # 変換後の画像を再度アタッチ
    Tempfile.create([attachment_name.to_s, '.jpg']) do |file|
      file.binmode
      file.write(processed_image.read)
      file.rewind

      attachment.attach(io: file, filename: "#{attachment_name}.jpg", content_type: 'image/jpeg')
    end
  ensure
    tempfile.close
    tempfile.unlink
  end
end
