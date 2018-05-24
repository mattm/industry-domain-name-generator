module IndustryNameGenerator
	TMP_DIR = "tmp"
	RESULTS_DIR = "results"
	ALL_DOMAINS_FILENAME = "domains.txt"
	COMMON_NAMES_FILENAME = "common.txt"

	# This is the industry you want to find available domains for
	INDUSTRY = "marketing"

	# These are other industies whose common names you want to check availability for
	SIMILAR_INDUSTRIES = %w{advertising media design}

	def self.run
		puts "Finding available domains for #{INDUSTRY}..."

		ensure_domains_file_exists!
		make_tmp_dir
		make_results_dir
		generate_industry_domain_lists
		generate_common_names_list
		generate_available_domains_for_industry

		puts "Done, results available in #{industry_results_path}"
	end

	def self.generate_industry_domain_lists
		puts "Generating industry name lists..."
		all_industries.each do |industry|
			path = industry_list_path(industry)
			unless File.exists?(path)
				puts "Searching for domains that end with '#{industry}'..."

				# Search for all the domains that end with the industry name
				# Then remove that industry name from the end of it
				# And finally sort and save the results
				cmd "LC_ALL=C grep #{industry.upcase}$ #{ALL_DOMAINS_FILENAME} | sed 's/.\\\{#{industry.length}\\\}$//' | sort -u > #{path}"
			end
		end
	end

	def self.generate_common_names_list
		puts "Finding common names in industries..."
		if similar_industries.length > 1
			command = "comm -12"
			similar_industries.each_with_index do |industry, index|
				path = industry_list_path(industry)
				if index <= 1
					command += " #{path}"
				else
					command += " | comm -12 - #{path}"
				end
			end
		else
			command = "cat #{TMP_DIR}/#{similar_industries.first}.txt"
		end

		# Generate a list of names shared by the similar industries
		cmd "#{command} | sort -u > #{common_list_path}"
	end

	def self.generate_available_domains_for_industry
		puts "Finding names not registered for #{INDUSTRY}..."
		industry_path = industry_list_path(INDUSTRY)
		cmd "comm -23 #{common_list_path} #{industry_path} > #{industry_results_path}"
	end

	def self.ensure_domains_file_exists!
		raise "Cannot find domains file: #{ALL_DOMAINS_FILENAME}" unless File.exist?(ALL_DOMAINS_FILENAME)
	end

	def self.make_tmp_dir
		Dir.mkdir(TMP_DIR) unless Dir.exist?(TMP_DIR)
	end

	def self.make_results_dir
		Dir.mkdir(RESULTS_DIR) unless Dir.exist?(RESULTS_DIR)
	end

	def self.industry_list_path(industry)
		"#{TMP_DIR}/#{industry}.txt"
	end

	def self.common_list_path
		"#{TMP_DIR}/#{COMMON_NAMES_FILENAME}"
	end

	def self.industry_results_path
		"#{RESULTS_DIR}/#{INDUSTRY}.txt"
	end

	def self.all_industries
		(SIMILAR_INDUSTRIES + [INDUSTRY]).uniq
	end

	def self.similar_industries
		# Just in case the industry is also in the list of similar industries
		(SIMILAR_INDUSTRIES - [INDUSTRY]).uniq
	end

	def self.cmd(command)
		puts "  " + command
		`#{command}`
	end
end

IndustryNameGenerator.run
