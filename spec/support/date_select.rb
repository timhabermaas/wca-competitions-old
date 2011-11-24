module Capybara
  module DateSelect
    def fill_in_date(selector, options)
      date = options[:with]
      from = options[:model] ? "#{options[:model]}_#{selector}" : selector.to_s

      if date.is_a? Date
        select date.year.to_s, :from => "#{from}_1i"
        select date.strftime("%B"), :from => "#{from}_2i"
        select date.day.to_s, :from => "#{from}_3i"
      end
      if date.is_a? DateTime or date.is_a? Time
        select date.minute.to_s, :from => "#{from}_4i"
        select date.second, :from => "#{from}_5i"
      end
    end
  end
end