# encoding: utf-8

namespace :naobzore do
  namespace :subscribes do
    desc "Send subscribes mails. Mail has goods services campaigns jobs, created today. Every day"
    task :send => :environment do
      mail_counter = 0
      User.joins(:subscribes).group('users.id').each do |user|
        category_ids = user.subscribes.map(&:category_id)
        next if category_ids.empty?
        tables = %w(goods services campaigns jobs)
        tables.each do |table|
          instance_variable_set("@#{table}", table.classify.constantize.where(:category_id => category_ids).where('created_at > ? AND created_at <= ?', Time.now - 1.day, Time.now))
        end
        next if (tables_data = tables.map { |t| instance_variable_get("@#{t}") }.flatten).empty?
        @companies = Company.where(:id => tables_data.map(&:company_id))
        @news = News.where(:category_id => category_ids).where('created_at > ? AND created_at <= ?', Time.now - 1.day, Time.now)
        next if @companies.empty? && @news.empty?
        SubscribesMailer.subscribes_send(user, @companies, @goods, @services, @campaigns, @jobs, @news).deliver
        puts 'Отправка письма пользователю: ' + user.email
        mail_counter += 1
      end
      puts 'Отправлено писем: ' + mail_counter.to_s
    end
  end

  namespace :packages do
    desc "Prolongation of companies_packages with auto flag. Every day"
    task :prolongate => :environment do
      # берем авто пакеты, которые заканчиваются в ближайшие сутки
      CompaniesPackage.unscoped.where(:auto => true).where('end_at >= ? AND end_at < ?', Time.now, Time.now + 1.day).each do |p|
        # смотрим, не продлён ли уже этот пакет
        if CompaniesPackage.where(:company_id => p.company_id, :package_id => p.package_id).where('end_at > ?', p.end_at).blank?
          puts "CompaniesPackage #{p.id} prolongation"
          # продлеваем
          CompaniesPackage.create(:company_id => p.company_id, :package_id => p.package_id, :start_at => p.end_at, :end_at => p.end_at + (p.end_at.month - p.start_at.month).months, :auto => true)
        end
      end
    end

    desc 'Delete packages by delete_after field'
    task :delete => :environment do
      Package.where('delete_after < ?', Date.today).each do |package|
        puts package.inspect
        package.destroy
      end
    end
  end

  namespace :banners do
    desc "Create acts and factures. Run only once per week"
    task :acts_factures => :environment do
      # Находим баннеры закончившиеся на прошлой неделе
      Banner.select('COUNT(id) AS cnt, company_id').where(:week => (Date.today - 1.week).cweek).group(:company_id).each do |banner|
        puts "#{banner.cnt} banners for company #{banner.company_id}"
        # создаём акт и счёт фактуру
        act = Act.create(:company_id => banner.company_id, :sum => sum = banner.cnt * Banner.week_price, :entity_type => 'Banner')
        Facture.create(:company_id => banner.company_id, :sum => sum, :act_id => act.id, :entity_type => 'Banner')
      end
    end
  end

  namespace :notifications do
    desc "Send notification to company if balance is less than minimal package price"
    task :send => :environment do
      companies = Company.where('id != ?', Company.main.try(:id)).select do |company|
        if company.balance < Package.for_company(company).pluck(:price).min
          puts "Send notification to company #{company.name}"
          true
        end
      end
      users = companies.map(&:user)
      # send message
      message = Message.create(:from_id => Company.main.user.id, :mtype => :notification, :text => 'Ваш баланс близок к нулю')
      message.receivers = users
      # send email
      users.each do |user|
        NotificationsMailer.balance_notification(user).deliver
      end
    end
  end

  namespace :read_marks do
    desc "Задача не позволяет разрастаться таблице read_marks. Вызов mark_as_read :all удаляет ненужные записи, сохраняя временную отметку"
    task :compact => :environment do
      # TODO
    end
  end
end
