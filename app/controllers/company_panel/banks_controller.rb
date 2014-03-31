# encoding: utf-8

class CompanyPanel::BanksController < CompanyPanel::BaseController
  before_filter :find_bank, :only => [:edit, :update, :destroy]
  before_filter :set_phone, :only => [:create, :update]

  def index
    @banks = Bank.all
    redirect_to new_company_panel_bank_path if @banks.empty?
  end

  def new
    @bank = Bank.new
  end

  def create
    @bank = Bank.new params[:bank]
    if @bank.save
      redirect_to company_panel_banks_path
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @bank.update_attributes(params[:bank])
      redirect_to company_panel_banks_path
    else
      render :index
    end
  end

  def destroy
    @bank.destroy
    redirect_to company_panel_banks_path
  end

  private

  def find_banks
  end

  def find_bank
    @bank = Bank.find params[:id]
  end

  def set_phone
    unless params[:phone_code].blank? && params[:phone_number].blank?
      params[:bank]['phone'] = "+7(#{params[:phone_code]})#{params[:phone_number]}"
    end
  end

  def set_widgets
    super
    @menu_controller = 'company_panel/deliveties'
  end
end
