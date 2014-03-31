# encoding: utf-8

class CompanyPanel::CompaniesController < CompanyPanel::BaseController
  before_filter :find_company
  before_filter :save_action

  def edit
  end

  def legal
  end

  def logotype
  end

  def tmp_logotype
    render :layout => false
  end

  def schedule
  end

  def crediting
  end

  def update
    if params[:phone_number]
      phone = []
      params[:phone_number].each_with_index do |phone_number, index|
        unless phone_number.blank?
          phone << "+7(#{params[:phone_code][index].gsub(/\D/, '')})#{phone_number}" + (params[:phone_dob][index].blank? ? '' : "(#{params[:phone_dob][index]})")
        end
      end
      params[:company]['phone'] = phone.join(';')
    end

    if params[:fax_number]
      fax = []
      params[:fax_number].each_with_index do |fax_number, index|
        unless fax_number.blank?
          fax << "+7(#{params[:fax_code][index].gsub(/\D/, '')})#{fax_number}"
        end
      end
      params[:company]['fax'] = fax.join(';')
    end

    %w(settlement_account post_index icq creation_year bik kpp bank_cor_account).each do |field|
      if params[:company][field]
        params[:company][field].gsub!(/\D/, '')
      end
    end

    success = if params[:company]['logotype']
      ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [
        "UPDATE companies SET logotype = ?, tmp_logotype = NULL WHERE id = ?", File.basename(params[:company]['logotype']), @company.id
      ]))
      true
    else 
      @company.update_attributes(params[:company])
    end
    respond_to do |format|
      format.html do
        if success
          redirect_to :controller => session['current_controller'], :action => session['current_action'], :id => @company.id
        else
          render session['current_action']
        end
      end
      format.json do
        if success
          render :json => { :success => true, :company => @company.to_json }
        else
          render :json => { :success => false, :errors => @company.errors.full_messages.to_json }
        end
      end
    end
  end

  private

  def find_company
    @company = current_user.account
  end

  def save_action
    session['current_controller'] = params[:controller] if request.method == 'GET'
    session['current_action'] = params[:action] if request.method == 'GET'
  end
end
