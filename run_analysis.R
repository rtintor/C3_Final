library(dplyr)
features <- read.delim("../features.txt", sep = " ", header = FALSE, stringsAsFactors = FALSE)
names <- features$V2
nfeatures <- 16
v_fw <- as.numeric(vector(length = 561)) + nfeatures
training <- read.fwf("../train/X_train.txt", header = FALSE, widths = v_fw)
names(training) <- names
test <- read.fwf("../test/X_test.txt", header = FALSE, widths = v_fw)
names(test) <- names
mset <- bind_rows(training, test)
v_mean <- grepl("mean", names)
v_std <- grepl("std",names)
v_all <- v_mean | v_std
need_names <- names[v_all]
final <- select(mset, need_names)
sneed_names <- lapply(need_names,tolower)
names(final)<-sneed_names
mset_means_t <- colMeans(mset)
mset_means <- as.data.frame(mset_means_t)