class Admin::ParkingRegistrationsController < ApplicationController
  def add_fee_field
    if session[:fee_field_index]
      session[:fee_field_index] += 1
    else
      session[:fee_field_index] = 1
    end
    @index = session[:fee_field_index]
  end

  def add_capacity_field
    if session[:capacity_field_index]
      session[:capacity_field_index] += 1
    else
      session[:capacity_field_index] = 1
    end
    @index = session[:capacity_field_index]
  end
end
