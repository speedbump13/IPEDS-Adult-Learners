install.packages("data.table")
install.packages("RODBC")

library(RODBC)


# Table list for IPEDS:
# HD<yyyy>: Directory information
# IC<yyyy>: Program and award level offerings
# IC<yyyy>_AY: Student charges for year
# EF<yyyy>A_DIST: Distance education status and level of students
# C<yyyy>_A: Awards/degrees conferred by program (6-digit CIP code), award level
# C<yyyy>_C: Number of students receiving awards/degrees, by award level
# C<yyyy>DEP: Number of programs offered and number of programs offered via distance 
# education
# FLAGS<YYYY>: Student response information
# DRVEF<yyyy>: Frequently derived variable for fall enrollment
# FLAGS<yyyy>: Response status for all survey components




IPEDS_path <- "../IPEDS-Adult-Learners/IPEDS_db/"
IPEDS_files <- list.files(path = IPEDS_path, pattern = "[^l]accdb")
IPEDS_years <- stringr::str_sub(IPEDS_files, 6, 9)
IPEDS_tables <- c("FLAGS")
IPEDS_tables <- data.frame(name = c("FLAGS<yyyy>",
                                    "EF<yyyy>B"),
                           description = c("Response status for all survey components",
                                           "Age category, gender, attendance status, and level of student: Fall 2014 (optional)"),
                           fieldlookup = c("FLAGS",
                                           "EFB"),
                           stringsAsFactors = FALSE)

IPEDS_fields <- list(ID = c("EFB"),
                     field_orig = list(c("LSTUDY","EFBAGE","EFAGE09","EFAGE07","EFAGE08","EFAGE05","EFAGE01","EFAGE02","EFAGE06","EFAGE03","EFAGE04","LINE")),
                     field_new  = list(c("Level of student","Age category","Grand total","Total men","Total women","Full time total","Full time men","Full time women","Part time total","Part time men","Part time women","Original line number on survey form")))

# Loop through each year 
for (i in 1:length(IPEDS_years)) {
  db <- paste(IPEDS_path,IPEDS_files[i], sep = "")
  channel <- odbcConnectAccess2007(db)
  #table <- sqlFetch(channel, "C2014_A")
  for (j in 1:length(IPEDS_tables$name)) {
    #assign(substr(IPEDS_files[1],1,regexpr('[.]',IPEDS_files[1])-1), sqlFetch(channel, paste(IPEDS_tables[1],IPEDS_years[i], sep = "")))
    #assign(paste(IPEDS_tables$name[j],IPEDS_years[i], sep = ""),
    #       sqlFetch(channel,paste(IPEDS_tables$name[j],IPEDS_years[i], sep = "")))
    assign(stringr::str_replace(IPEDS_tables$name[j], pattern = "<yyyy>", replacement = IPEDS_years[i]),
          sqlFetch(channel,stringr::str_replace(IPEDS_tables$name[j], pattern = "<yyyy>", replacement = IPEDS_years[i])))
  }
  close(channel)
}

# Format EF<yyyy>B tables - Age category, gender, attendance status, and level of student: Fall 2014 (optional)

# Rename headers
EFB_headers <- data.frame(varname=c("LSTUDY","EFBAGE","EFAGE09","EFAGE07","EFAGE08","EFAGE05","EFAGE01","EFAGE02","EFAGE06","EFAGE03","EFAGE04","LINE"),
                          vartitle=c("Level of student","Age category","Grand total","Total men","Total women","Full time total","Full time men","Full time women","Part time total","Part time men","Part time women","Original line number on survey form"),
                          stringsAsFactors = FALSE)

data.table::setnames(EF2014B, old = EFB_headers$varname, new=EFB_headers$vartitle)




