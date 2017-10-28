library(dplyr)
library(reshape2)
features <- read.delim("../features.txt", sep = " ", header = FALSE, stringsAsFactors = FALSE)
names <- features$V2
nfeatures <- 16
v_fw <- as.numeric(vector(length = 561)) + nfeatures
training <- read.fwf("../train/X_train.txt", header = FALSE, widths = v_fw)
training_subject <- read.fwf("../train/subject_train.txt", header = FALSE, widths = c(5))
training_activity <- read.fwf("../train/y_train.txt", header = FALSE, widths = c(5))
names(training) <- names
training_subject <- rename(training_subject, Subject = V1)
training_activity <- rename(training_activity, Activity = V1)
training_full <- cbind(training_subject, cbind(training_activity, training))
test <- read.fwf("../test/X_test.txt", header = FALSE, widths = v_fw)
test_subject <- read.fwf("../test/subject_test.txt", header = FALSE, widths = c(5))
test_activity <- read.fwf("../test/y_test.txt", header = FALSE, widths = c(5))
names(test) <- names
test_subject <- rename(test_subject, Subject = V1)
test_activity <- rename(test_activity, Activity = V1)
test_full <- cbind(test_subject, cbind(test_activity, test))
mset <- bind_rows(training_full, test_full)
v_mean <- grepl("mean()", names)
v_std <- grepl("std()",names)
v_all <- v_mean | v_std
need_names <- names[v_all]
need_names <- c("Subject","Activity", need_names)
final <- select(mset, need_names)
final <- arrange(final, Subject, Activity)

final_means <- final %>% group_by(Subject, Activity)%>% summarise_all(mean)
write.table(final_means,row.name=FALSE, "dataset.txt")