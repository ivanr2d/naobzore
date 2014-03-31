class Statistic < ActiveRecord::Base
  attr_accessible :entity_id, :entity_type, :ip, :time, :user_id

  before_validation { self.time = Time.now.utc.to_i }

	def self.by entity_type, opts = {}
    opts = {:from => Time.now.to_i - 1.month, :to => Time.now.to_i, :step => 1.day.to_i}.merge(opts)
    res = {}
		entities = opts[:company_id] ? entity_type.constantize.where(:company_id => opts[:company_id]) : entity_type.constantize.all
    entities.each { |e| res[e.id] = {'label' => e.name, 'data' => {}} }
    (opts[:from] + opts[:step] .. opts[:to]).step(opts[:step].to_i) do |t|
      t_with_offset = (t + Time.new.utc_offset) * 1000
      res.keys.each { |entity_id| res[entity_id]['data'][t_with_offset] = 0 }
			if opts[:company_id]
				entity_table = entity_type.tableize
				data = ActiveRecord::Base.connection.select(ActiveRecord::Base.send('sanitize_sql_array', [
					"SELECT entity_id, COUNT(DISTINCT(ip)) AS cnt FROM statistics INNER JOIN #{entity_table} ON entity_id = #{entity_table}.id WHERE entity_type = '#{entity_type}' AND time >= ? AND time < ? AND #{entity_table}.company_id = ? GROUP BY entity_id ", t - opts[:step], t, opts[:company_id]
				]))
			else
				data = ActiveRecord::Base.connection.select(ActiveRecord::Base.send('sanitize_sql_array', [
					'SELECT entity_id, COUNT(DISTINCT(ip)) AS cnt FROM statistics WHERE entity_type = "' + entity_type + '" AND time >= ? AND time < ? GROUP BY entity_id ', t - opts[:step], t
				]))
			end
      data.each { |d| res[d['entity_id']]['data'][t_with_offset] = d['cnt'] }
    end
    res.delete_if { |entity_id, stat| stat['data'].values.sum == 0 }
    res.each { |entity_id, stat| res[entity_id]['data'] = stat['data'].to_a }
    res
	end
end
