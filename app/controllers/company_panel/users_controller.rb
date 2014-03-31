# encoding: utf-8

class CompanyPanel::UsersController < CompanyPanel::BaseController
  before_filter :find_user, :only => [:edit, :update, :edit_password, :update_password, :edit_email, :update_email, :delete_account, :destroy]

  def edit
  end

  def update
    phone = []
    params[:phone_number].each_with_index do |phone_number, index|
      unless phone_number.blank?
        phone << "+7(#{params[:phone_code][index].gsub(/\D/, '')})#{phone_number}" + (params[:phone_dob][index].blank? ? '' : "(#{params[:phone_dob][index]})")
      end
    end
    params[:user]['phone'] = phone.join(';')
    params[:user]['prefered_contact'] = params[:prefered_contact].to_a.join(';')
    if @user.update_attributes params[:user]
      redirect_to edit_company_panel_user_path(@user), :notice => 'Изменения сохранены'
    else
      render :edit
    end
  end

  def edit_password
  end

  def update_password
    if !@user.valid_password?(params[:user]['current_password'])
      @user.errors.add(:base, 'Некорректный текущий пароль')
      render :edit_password
    elsif params[:user]['new_password'] != params[:user]['password_confirmation']
      @user.errors.add(:base, 'Пароли не совпадают')
      render :edit_password
    else
      @user.password = params[:user]['new_password']
      if @user.save
        redirect_to edit_password_company_panel_user_path(@user), :notice => 'Пароль изменён'
      else
        render :edit_password
      end
    end
  end

  def edit_email
  end

  def update_email
    if params[:current_email] == @user.email and @user.valid_password?(params[:user]['current_password'])
      @user.email = params[:user]['email']
      if params[:use_email_as_contact]
        @user.prefered_contact = @user.prefered_contacts.push('email').uniq.join(';')
      else
        @user.prefered_contact = @user.prefered_contacts.delete_if { |c| c == 'email' }.join(';')
      end
      if @user.save
        redirect_to edit_email_company_panel_user_path(@user), :notice => 'E-mail изменён'
      else
        render :edit_email
      end
    else
      @user.errors.add(:base, 'Некорректный текущий e-mail или пароль')
      render :edit_email
    end
  end

  def delete_account
  end

  def destroy
    if @user.valid_password? params[:user]['password']
      @user.destroy
      redirect_to root_path, :notice => 'Аккаунт удалён'
    else
      @user.errors.add(:base, 'Некорректный текущий пароль')
      render :delete_account
    end
  end

  def search
    @users = User.where('f_name like :q or l_name like :q or m_name like :q', :q => "%#{params[:q].strip}%").where("id not in (#{current_user.account.users.map(&:id).push(current_user.id).join(',')})")
    respond_to do |format|
      format.json { render :json => @users }
    end
  end

  private

  def find_user
    @user = User.find params[:id]
		if @user != current_user
			redirect_to company_panel_root_path, :notice => 'Нет доступа'
		end
  end
end
