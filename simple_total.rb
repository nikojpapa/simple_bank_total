require 'json'
require 'awesome_print'
require 'fileutils'
require 'optparse'

script_dir= File.absolute_path(File.dirname(__FILE__))

@options= {
	:txn_file=> "#{script_dir}/2017-03-06-exported_transactions.json",
}

OptionParser.new do |opts|
	


end.parse!

exported_txns= JSON.parse(File.read(@options[:txn_file]))

total = 0

transactions = exported_txns["transactions"].reverse
transactions_count = transactions.count
txns_on_last_page = transactions_count % 50 #50 transactions per page
transactions.each_with_index do |txn, index|
	ap "(#{index+1}/#{transactions_count})"
	puts (index + 1 <= txns_on_last_page) ? "Page 20" : "Page #{19 - (index - txns_on_last_page) / 50}"

	txn_id 				= txn["uuid"]
	description 		= txn["description"]
	bookkeeping_type 	= txn["bookkeeping_type"]
	amount 				= txn["amounts"]["amount"] / 10000.0

	if !(['credit','debit'].include?(bookkeeping_type))
		ap "WEIRD TYPE"
		ap bookkeeping_type
		exit
	end
	next if description=="Transfer From Simple Migration Initial Balance Transfer"

	puts description

	if bookkeeping_type == 'credit'
		# ap "CREDIT"
		print "#{total} + #{amount}"
		total += amount
	else
		print "#{total} - #{amount}"
		total -= amount
	end

	puts " = #{total}"
	puts
end

# FileUtils.copy_file(@options[:info_file], "#{@options[:info_file]}.bak")
# File.new(@options[:info_file], "w")
# File.open(@options[:info_file], "w"){|file| file.write(new_info.to_json)}
ap total


