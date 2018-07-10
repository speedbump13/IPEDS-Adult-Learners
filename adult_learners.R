

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




IPEDS_path <- "../IPEDS-Adult-Learners/IPEDS_db/"
IPEDS_files <- list.files(path = IPEDS_path, pattern = "[^l]accdb")

#for (i in 1:length(IPEDS_files)) {
for (i in 1:1) {
  db <- paste(IPEDS_path,IPEDS_files[i], sep = "")
  channel <- odbcConnectAccess2007(db)
  #table <- sqlFetch(channel, "C2014_A")
  assign(substr(IPEDS_files[1],1,regexpr('[.]',IPEDS_files[1])-1), sqlFetch(channel, "C2014_A"))
  close(channel)
}

#db <-file.path("../IPEDS-Adult-Learners/IPEDS_db/IPEDS201415.accdb")
#db <- IPEDS_files[1]
#channel <- odbcConnectAccess2007(db)

#tb_C2016_A <- sqlFetch(channel, "C2016_A")

#close(channel)