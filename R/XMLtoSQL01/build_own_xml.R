library("xml2")
library("XML")
library("igraph")

source("./func__process_objects.R")
source("./func__write_sql.R")

## global variables ##########
counters_env <<- new.env()
counters_env$select_no <- 0
counters_env$source_no <- 0

#read xml
#xml_input <- read_xml("example.XML")
#xml_input <- read_xml("../test_files/hard_m_om_sde_li_dim.xml")
xml_input <- read_xml("../test_files/hard_m_om_sde_li_dim.XML")

#xml_input <- read_xml("/test_files/example.xml")

## connectory medzi objektmi ########
connectors_all <- xml_find_all(xml_input, ".//CONNECTOR")
all_objects <- c()
from_instance <- c()
to_instance <- c()
from_field <- c()
to_field <- c()
for (con_i in 1:length(connectors_all)) {
  from_instance <- append(from_instance, xml_attr(connectors_all[con_i], "FROMINSTANCE"))
  to_instance <- append(to_instance, xml_attr(connectors_all[con_i], "TOINSTANCE"))
  from_field <- append(from_field, xml_attr(connectors_all[con_i], "FROMFIELD"))
  to_field <- append(to_field, xml_attr(connectors_all[con_i], "TOFIELD"))
} 
connectors_all_df <- data.frame(from_instance, to_instance, from_field, to_field, stringsAsFactors = F)
connectors_unique_df <<- unique(data.frame(from_instance, to_instance, stringsAsFactors = F))
 all_objects <- unique(append(from_instance,to_instance))
rm("from_instance", "to_instance", "from_field", "to_field")


## XML query
# TODO: managing branching :
# map/find all simple forward branches that can be processed as a whole
# they can be determined like - starts at SOURCE, end at join/union, there starts another, final one ends at TARGET
# get needed requirements for every branch (SOURCES have none, those starting at JOIN need those two for join...)
# put all branches in a queue, pop by one from que and process them, till they are all processed
# pop from queue first branch that has requirements met

# find all sources ################ 
print(connectors_unique_df)

sources <- xml_find_all(xml_input, ".//SOURCE")
g<-graph.data.frame(d = connectors_unique_df, directed = TRUE)
sorted <- topo_sort(g, mode = c("out"))

cat("\r\n")
print("=========================topology order==================================")
print(as.matrix(sorted))

cat("\r\n")

xml_query <- newXMLDoc()

for (i in  1:length(sorted)){
	print(paste0("-------",as_ids(sorted[i]), " : ",i))
	xml_query <- newXMLDoc()

	#connectors_unique_df[nrow(connectors_unique_df)+1,] = list("START",xml_attr(src, "NAME"))
	process_general_object(xml_query, NULL, xml_input, as_ids(sorted[i]))
	#writeLines(sql_query)
}
#sql_query <- xml_to_sql(xml_query)

# connectors_unique_df$processed <- rep(0,length(connectors_unique_df$to_instance))
# print("###############################################################")
# print(connectors_unique_df)


# xml_query <- newXMLDoc()
# xml_query <- process_general_object(xml_query, NULL, xml_input, "START")
# #print(xml_query)

# sql_query <- xml_to_sql(xml_query)
# writeLines(sql_query)

# print(xml_query)
# ## SQL query
# sql_query <- xml_to_sql(xml_query)

# ## output at end
# writeLines("")
# writeLines("output:")
# print(xml_query)
# writeLines(sql_query)


