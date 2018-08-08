require 'open-uri'
require 'json'

fips = []
state_data = []

puts "Which states do you want data on? (Please separate with commas, no spaces after commas)"
states = gets.chomp.gsub(' ','_')
states = states.downcase.split(',')
states = states.sort
puts states
# WE SHOULD PULL OUT SPACES AFTER COMMAS RATHER THAN ASKING USER
puts "Would you like a CSV or averages?"
output = gets.chomp
    until ["csv","averages"].include? output do
        puts "Please enter either 'CSV' or 'averages'" 
        output = gets.chomp
    end

states.each do |state|
    build_state = 'https://www.broadbandmap.gov/broadbandmap/census/state/' + state + '?format=json'
    fips_uri = URI.parse(build_state)
    fips_data = JSON.parse(fips_uri.open{|file| file.readlines }.join)
    fips << fips_data["Results"]["state"][0]["fips"].to_s
end    
#IF THEY PUT IN BAD STATE SPELLING, WE SHOULD CALL THAT OUT HERE - JUST PRINT DATA["MESSAGE"]

fips.each do |fip|
    build_census = 'https://www.broadbandmap.gov/broadbandmap/demographic/jun2014/state/ids/' + fip + '?format=json'
    census_uri = URI.parse(build_census)
    census_data = JSON.parse(census_uri.open{|file| file.readlines }.join)
    state_data << census_data
end

if output.downcase == "csv"
	# DOES THE CSV WANT HEADERS? <state name>,<population>,<households>, <income below poverty>,<median income>
    state_data.each do |state|
        puts state["Results"][0]["geographyName"] + ',' + state["Results"][0]["population"].to_s + ',' + state["Results"][0]["households"].to_s + ',' + state["Results"][0]["incomeBelowPoverty"].to_s + ',' + state["Results"][0]["medianIncome"].to_s 
    end
else
	# THIS IS ASSUMING INCOME BELOW POVERTY IS BASED ON POPULATION, NOT HAOUSEHOLDS - VERIFY!
	pop = []
	poverty = []
	state_data.each do |state|
            pop << state["Results"][0]["population"]
	    poverty << state["Results"][0]["population"] * state["Results"][0]["incomeBelowPoverty"]
	end
	# ASSUMPTION: Multiplying by 100 - instructions say "integer" but results default to floats; assuming we want a percent of total pop result
	avg = (poverty.inject(0){|sum,x| sum + x } / pop.inject(0){|sum,x| sum + x }) * 100
	avg = avg.round.to_s
	puts "average: " + avg
end
