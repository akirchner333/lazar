class User < ApplicationRecord
	has_many :posts
	has_many :likes
	has_secure_password

	validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
	validates :username, presence: true, uniqueness: true

	def self.name_gen
		"#{FLOWERS.sample}_#{JOBS.sample}".downcase.gsub(" ", "_")
	end

	def self.from_omniauth(auth)
		if auth.provider == "google_oauth2"
			where(email: auth.info.email).first_or_initialize do |user|
				user.email = auth.info.email
				user.password_digest ||= SecureRandom.hex
				user.username ||= self.name_gen
			end
		end
	end

	FLOWERS = [
		"anemone",
	    "amaryllis",
	    "amaranth",
	    "aster",
	    "azalea",
	    "babys breath",
	    "begonia",
	    "bellflower",
	    "bergamot",
	    "bird of paradise",
	    "bluebell",
	    "bottlebrush",
	    "buttercup",
	    "camellias",
	    "carnation",
	    "chrysantemum",
	    "columbine",
	    "clover",
	    "crocus",
	    "daisy",
	    "dahlia",
	    "daffodil",
	    "delphinium",
	    "edelweiss",
	    "primrose",
	    "forget me not",
	    "foxglove",
	    "freesia",
	    "gerbera daisy",
	    "gladiolus",
	    "hibiscus",
	    "heather",
	    "hyacinth",
	    "holly",
	    "iris",
	    "jasmine",
	    "ladys slipper",
	    "lavender",
	    "lilac",
	    "lily",
	    "lotus flower",
	    "marigold",
	    "marjoram",
	    "mimosa",
	    "narcissus",
	    "orange blossom",
	    "orchid",
	    "peach blossom",
	    "peony",
	    "petunia",
	    "rhododendron",
	    "rosemary",
	    "roses",
	    "sage",
	    "snapdragon",
	    "sunflower",
	    "tansy",
	    "thistle",
	    "thyme",
	    "tulip",
	    "violet",
	    "water lily",
	    "zinnia"
	]

	JOBS = [
		"gas pumping station operator",
	    "general manager",
	    "general practitioner",
	    "geographer",
	    "geography teacher",
	    "geological engineer",
	    "geological technician",
	    "geoscientist",
	    "glazier",
	    "government program eligibility interviewer",
	    "graduate teaching assistant",
	    "graphic designer",
	    "groundskeeper",
	    "groundskeeping worker",
	    "gynecologist",
	    "hairdresser",
	    "hairstylist",
	    "hand grinding worker",
	    "hand laborer",
	    "hand packager",
	    "hand packer",
	    "hand polishing worker",
	    "hand sewer",
	    "hazardous materials removal worker",
	    "head cook",
	    "health and safety engineer",
	    "health educator",
	    "health information technician",
	    "health services manager",
	    "health specialties teacher",
	    "healthcare social worker",
	    "hearing officer",
	    "heat treating equipment setter",
	    "heating installer",
	    "heating mechanic",
	    "heavy truck driver",
	    "highway maintenance worker",
	    "historian",
	    "history teacher",
	    "hoist and winch operator",
	    "home appliance repairer",
	    "home economics teacher",
	    "home entertainment installer",
	    "home health aide",
	    "home management advisor",
	    "host",
	    "hostess",
	    "hostler",
	    "hotel desk clerk",
	    "housekeeping cleaner",
	    "human resources assistant",
	    "human resources manager",
	    "human service assistant",
	    "hunter",
	    "hydrologist",
	    "illustrator",
	    "industrial designer",
	    "industrial engineer",
	    "industrial engineering technician",
	    "industrial machinery mechanic",
	    "industrial production manager",
	    "industrial truck operator",
	    "industrial-organizational psychologist",
	    "information clerk",
	    "information research scientist",
	    "information security analyst",
	    "information systems manager",
	    "inspector",
	    "instructional coordinator",
	    "instructor",
	    "insulation worker",
	    "insurance claims clerk",
	    "insurance sales agent",
	    "insurance underwriter",
	    "intercity bus driver",
	    "interior designer",
	    "internist",
	    "interpreter",
	    "interviewer",
	    "investigator",
	    "jailer",
	    "janitor",
	    "jeweler",
	    "judge",
	    "judicial law clerk",
	    "kettle operator",
	    "kiln operator",
	    "kindergarten teacher",
	    "laboratory animal caretaker",
	    "landscape architect",
	    "landscaping worker",
	    "lathe setter",
	    "laundry worker",
	    "law enforcement teacher",
	    "law teacher",
	    "lawyer",
	    "layout worker",
	    "leather worker",
	    "legal assistant",
	    "legal secretary",
	    "legislator",
	    "librarian",
	    "library assistant",
	    "library science teacher",
	    "library technician",
	    "licensed practical nurse",
	    "licensed vocational nurse",
	    "life scientist",
	    "lifeguard",
	    "light truck driver",
	    "line installer",
	    "literacy teacher",
	    "literature teacher",
	    "loading machine operator",
	    "loan clerk",
	    "loan interviewer",
	    "loan officer",
	    "lobby attendant",
	    "locker room attendant",
	    "locksmith",
	    "locomotive engineer",
	    "locomotive firer",
	    "lodging manager",
	    "log grader",
	    "logging equipment operator",
	    "logistician",
	    "machine feeder",
	    "machinist",
	    "magistrate judge",
	    "magistrate",
	    "maid",
	    "mail clerk",
	    "mail machine operator",
	    "mail superintendent",
	    "maintenance painter",
	    "maintenance worker",
	    "makeup artist",
	    "management analyst",
	    "manicurist",
	    "manufactured building installer",
	    "mapping technician",
	    "marble setter",
	    "marine engineer",
	    "marine oiler",
	    "market research analyst",
	    "marketing manager",
	    "marketing specialist",
	    "marriage therapist",
	    "massage therapist",
	    "material mover",
	    "materials engineer",
	    "materials scientist",
	    "mathematical science teacher",
	    "mathematical technician",
	    "mathematician",
	    "maxillofacial surgeon",
	    "measurer",
	    "meat cutter",
	    "meat packer",
	    "meat trimmer",
	    "mechanical door repairer",
	    "mechanical drafter",
	    "mechanical engineer",
	    "mechanical engineering technician",
	    "mediator",
	    "medical appliance technician",
	    "medical assistant",
	    "medical equipment preparer",
	    "medical equipment repairer",
	    "medical laboratory technician",
	    "medical laboratory technologist",
	    "medical records technician",
	    "medical scientist",
	    "medical secretary",
	    "medical services manager",
	    "medical transcriptionist",
	    "meeting planner",
	    "mental health counselor",
	    "mental health social worker",
	    "merchandise displayer",
	    "messenger",
	    "metal caster",
	    "metal patternmaker",
	    "metal pickling operator",
	    "metal pourer",
	    "metal worker",
	    "metal-refining furnace operator",
	    "metal-refining furnace tender",
	    "meter reader",
	    "microbiologist",
	    "middle school teacher",
	    "milling machine setter",
	    "millwright",
	    "mine cutting machine operator",
	    "mine shuttle car operator",
	    "mining engineer",
	    "mining safety engineer",
	    "mining safety inspector",
	    "mining service unit operator",
	    "mixing machine setter",
	    "mobile heavy equipment mechanic",
	    "mobile home installer",
	    "model maker",
	    "model",
	    "molder",
	    "mortician",
	    "motel desk clerk",
	    "motion picture projectionist",
	    "motorboat mechanic",
	    "motorboat operator",
	    "motorboat service technician",
	    "motorcycle mechanic",
	    "multimedia artist",
	    "museum technician",
	    "music director",
	    "music teacher",
	    "musical instrument repairer",
	    "musician",
	    "natural sciences manager",
	    "naval architect",
	    "network systems administrator",
	    "new accounts clerk",
	    "news vendor",
	    "nonfarm animal caretaker",
	    "nuclear engineer",
	    "nuclear medicine technologist",
	    "nuclear power reactor operator",
	    "nuclear technician",
	    "nursing aide",
	    "nursing instructor",
	    "nursing teacher",
	    "nutritionist",
	    "obstetrician",
	    "occupational health and safety specialist",
	    "occupational health and safety technician",
	    "occupational therapist",
	    "occupational therapy aide",
	    "occupational therapy assistant",
	    "offbearer",
	    "office clerk",
	    "office machine operator",
	    "operating engineer",
	    "operations manager",
	    "operations research analyst",
	    "ophthalmic laboratory technician",
	    "optician",
	    "optometrist",
	    "oral surgeon",
	    "order clerk",
	    "order filler",
	    "orderly",
	    "ordnance handling expert",
	    "orthodontist",
	    "orthotist",
	    "outdoor power equipment mechanic",
	    "oven operator",
	    "packaging machine operator",
	    "painter ",
	    "painting worker",
	    "paper goods machine setter",
	    "paperhanger",
	    "paralegal",
	    "paramedic",
	    "parking enforcement worker",
	    "parking lot attendant",
	    "parts salesperson",
	    "paving equipment operator",
	    "payroll clerk",
	    "pediatrician",
	    "pedicurist",
	    "personal care aide",
	    "personal chef",
	    "personal financial advisor",
	    "pest control worker",
	    "pesticide applicator",
	    "pesticide handler",
	    "pesticide sprayer",
	    "petroleum engineer",
	    "petroleum gauger",
	    "petroleum pump system operator",
	    "petroleum refinery operator",
	    "petroleum technician",
	    "pharmacist",
	    "pharmacy aide",
	    "pharmacy technician",
	    "philosophy teacher",
	    "photogrammetrist",
	    "photographer",
	    "photographic process worker",
	    "photographic processing machine operator",
	    "physical therapist aide",
	    "physical therapist assistant",
	    "physical therapist",
	    "physician assistant",
	    "physician",
	    "physicist",
	    "physics teacher",
	    "pile-driver operator",
	    "pipefitter",
	    "pipelayer",
	    "planing machine operator",
	    "planning clerk",
	    "plant operator",
	    "plant scientist",
	    "plasterer",
	    "plastic patternmaker",
	    "plastic worker",
	    "plumber",
	    "podiatrist",
	    "police dispatcher",
	    "police officer",
	    "policy processing clerk",
	    "political science teacher",
	    "political scientist",
	    "postal service clerk",
	    "postal service mail carrier",
	    "postal service mail processing machine operator",
	    "postal service mail processor",
	    "postal service mail sorter",
	    "postmaster",
	    "postsecondary teacher",
	    "poultry cutter",
	    "poultry trimmer",
	    "power dispatcher",
	    "power distributor",
	    "power plant operator",
	    "power tool repairer",
	    "precious stone worker",
	    "precision instrument repairer",
	    "prepress technician",
	    "preschool teacher",
	    "priest",
	    "print binding worker",
	    "printing press operator",
	    "private detective",
	    "probation officer",
	    "procurement clerk",
	    "producer",
	    "product promoter",
	    "production clerk",
	    "production occupation",
	    "proofreader",
	    "property manager",
	    "prosthetist",
	    "prosthodontist",
	    "psychiatric aide",
	    "psychiatric technician",
	    "psychiatrist",
	    "psychologist",
	    "psychology teacher",
	    "public relations manager",
	    "public relations specialist",
	    "pump operator",
	    "purchasing agent",
	    "purchasing manager",
	    "radiation therapist",
	    "radio announcer",
	    "radio equipment installer",
	    "radio operator",
	    "radiologic technician",
	    "radiologic technologist",
	    "rail car repairer",
	    "rail transportation worker",
	    "rail yard engineer",
	    "rail-track laying equipment operator",
	    "railroad brake operator",
	    "railroad conductor",
	    "railroad police",
	    "rancher",
	    "real estate appraiser",
	    "real estate broker",
	    "real estate manager",
	    "real estate sales agent",
	    "receiving clerk",
	    "receptionist",
	    "record clerk",
	    "recreation teacher",
	    "recreation worker",
	    "recreational therapist",
	    "recreational vehicle service technician",
	    "recyclable material collector",
	    "referee",
	    "refractory materials repairer",
	    "refrigeration installer",
	    "refrigeration mechanic",
	    "refuse collector",
	    "regional planner",
	    "registered nurse",
	    "rehabilitation counselor",
	    "reinforcing iron worker",
	    "reinforcing rebar worker",
	    "religion teacher",
	    "religious activities director",
	    "religious worker",
	    "rental clerk",
	    "repair worker",
	    "reporter",
	    "residential advisor",
	    "resort desk clerk",
	    "respiratory therapist",
	    "respiratory therapy technician",
	    "retail buyer",
	    "retail salesperson",
	    "revenue agent",
	    "rigger",
	    "rock splitter",
	    "rolling machine tender",
	    "roof bolter",
	    "roofer",
	    "rotary drill operator",
	    "roustabout",
	    "safe repairer",
	    "sailor",
	    "sales engineer",
	    "sales manager",
	    "sales representative",
	    "sampler",
	    "sawing machine operator",
	    "scaler",
	    "school bus driver",
	    "school psychologist",
	    "school social worker",
	    "scout leader",
	    "sculptor",
	    "secondary education teacher",
	    "secondary school teacher",
	    "secretary",
	    "securities sales agent",
	    "security guard",
	    "security system installer",
	    "segmental paver",
	    "self-enrichment education teacher",
	    "semiconductor processor",
	    "septic tank servicer",
	    "set designer",
	    "sewer pipe cleaner",
	    "sewing machine operator",
	    "shampooer",
	    "shaper",
	    "sheet metal worker",
	    "sheriff's patrol officer",
	    "ship captain",
	    "ship engineer",
	    "ship loader",
	    "shipmate",
	    "shipping clerk",
	    "shoe machine operator",
	    "shoe worker",
	    "short order cook",
	    "signal operator",
	    "signal repairer",
	    "singer",
	    "ski patrol",
	    "skincare specialist",
	    "slaughterer",
	    "slicing machine tender",
	    "slot supervisor",
	    "social science research assistant",
	    "social sciences teacher",
	    "social scientist",
	    "social service assistant",
	    "social service manager",
	    "social work teacher",
	    "social worker",
	    "sociologist",
	    "sociology teacher",
	    "software developer",
	    "software engineer",
	    "soil scientist",
	    "solderer",
	    "sorter",
	    "sound engineering technician",
	    "space scientist",
	    "special education teacher",
	    "speech-language pathologist",
	    "sports book runner",
	    "sports entertainer",
	    "sports performer",
	    "stationary engineer",
	    "statistical assistant",
	    "statistician",
	    "steamfitter",
	    "stock clerk",
	    "stock mover",
	    "stonemason",
	    "street vendor",
	    "streetcar operator",
	    "structural iron worker",
	    "structural metal fabricator",
	    "structural metal fitter",
	    "structural steel worker",
	    "stucco mason",
	    "substance abuse counselor",
	    "substance abuse social worker",
	    "subway operator",
	    "surfacing equipment operator",
	    "surgeon",
	    "surgical technologist",
	    "survey researcher",
	    "surveying technician",
	    "surveyor",
	    "switch operator",
	    "switchboard operator",
	    "tailor",
	    "tamping equipment operator",
	    "tank car loader",
	    "taper",
	    "tax collector",
	    "tax examiner",
	    "tax preparer",
	    "taxi driver",
	    "teacher assistant",
	    "teacher",
	    "team assembler",
	    "technical writer",
	    "telecommunications equipment installer",
	    "telemarketer",
	    "telephone operator",
	    "television announcer",
	    "teller",
	    "terrazzo finisher",
	    "terrazzo worker",
	    "tester",
	    "textile bleaching operator",
	    "textile cutting machine setter",
	    "textile knitting machine setter",
	    "textile presser",
	    "textile worker",
	    "therapist",
	    "ticket agent",
	    "ticket taker",
	    "tile setter",
	    "timekeeping clerk",
	    "timing device assembler",
	    "tire builder",
	    "tire changer",
	    "tire repairer",
	    "title abstractor",
	    "title examiner",
	    "title searcher",
	    "tobacco roasting machine operator",
	    "tool filer",
	    "tool grinder",
	    "tool maker",
	    "tool sharpener",
	    "tour guide",
	    "tower equipment installer",
	    "tower operator",
	    "track switch repairer",
	    "tractor operator",
	    "tractor-trailer truck driver",
	    "traffic clerk",
	    "traffic technician",
	    "training and development manager",
	    "training and development specialist",
	    "transit police",
	    "translator",
	    "transportation equipment painter",
	    "transportation inspector",
	    "transportation security screener",
	    "transportation worker",
	    "trapper",
	    "travel agent",
	    "travel clerk",
	    "travel guide",
	    "tree pruner",
	    "tree trimmer",
	    "trimmer",
	    "truck loader",
	    "truck mechanic",
	    "tuner",
	    "turning machine tool operator",
	    "typist",
	    "umpire",
	    "undertaker",
	    "upholsterer",
	    "urban planner",
	    "usher",
	    "valve installer",
	    "vending machine servicer",
	    "veterinarian",
	    "veterinary assistant",
	    "veterinary technician",
	    "vocational counselor",
	    "vocational education teacher",
	    "waiter",
	    "waitress",
	    "watch repairer",
	    "water treatment plant operator",
	    "weaving machine setter",
	    "web developer",
	    "weigher",
	    "welder",
	    "wellhead pumper",
	    "wholesale buyer",
	    "wildlife biologist",
	    "window trimmer",
	    "wood patternmaker",
	    "woodworker",
	    "word processor",
	    "writer",
	    "yardmaster",
	    "zoologist"
	]
end
