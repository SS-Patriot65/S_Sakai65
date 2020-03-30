##################################
# �ړI : �f�[�^���R�[�p�X���ɕύX����v���O����. 
# �\�[�X�R�[�h�� : df_to_corpus.R
# �o�[�W���� : SR(1)
# �ŏI�ύX���� : 2017.06.08, 16:56
# �쐬�� : Taniguchi Hidetaka
##################################

path <- getwd()

term_list_from_spam_and_ham <- c()

for(i in 1:length(spam.df$term)) {
	term_list_from_spam_and_ham[i] <- spam.df$term[i]
}

for(i in (length(spam.df$term) + 1):(length(spam.df$term) + length(easyham.df$term))) {
	term_list_from_spam_and_ham[i] <- easyham.df$term[i - length(spam.df$term)]
}

#�@spam �� ham �̑S�P�ꃊ�X�g
term_list_from_spam_and_ham <- sort(unique(term_list_from_spam_and_ham))

t <- c(1:length(term_list_from_spam_and_ham))

corpus <- c(1:length(term_list_from_spam_and_ham))

for(j in 1:length(corpus)) {
	corpus[j] <- 0
}

for(i in 1:length(spam.docs)) {

	con <- file(paste(path, "\\", CORPUS_NAME, "_data\\spam\\", spam.docs[i], sep=""), open = "rt", encoding = "latin1")
	text <- readLines(con)
	
	# The message always begins after the first full line break
	msg <- text
	close(con)
	msg <- paste(msg, collapse = "\n")
	
	#############################
	
	msg.corpus <- Corpus(VectorSource(msg))
	
	# Hard-coded TDM control
	control <- list(stopwords = TRUE,
			removePunctuation = TRUE,
			removeNumbers = TRUE)
	msg.tdm <- TermDocumentMatrix(msg.corpus, control)
	word.freq <- rowSums(as.matrix(msg.tdm))
	
	word.freq <- word.freq[which(word.freq >= 1)]

	for(j in 1:length(t)) {
		t[j] <- 0
	}

	for(j in 1:length(word.freq)) {
		if(length(which(names(word.freq[j]) == term_list_from_spam_and_ham))) {
			t[which(names(word.freq[j]) == term_list_from_spam_and_ham)] <- as.numeric(word.freq[j])
		}
	}

	corpus <- rbind(corpus, t)
}

############################################

for(i in (length(spam.docs) + 1):(length(spam.docs) + length(easyham.docs))) {

	con <- file(paste(path, "\\", CORPUS_NAME, "_data\\ham\\", easyham.docs[i-length(spam.docs)], sep=""), open = "rt", encoding = "latin1")
	text <- readLines(con)
	
	# The message always begins after the first full line break
	msg <- text
	close(con)
	msg <- paste(msg, collapse = "\n")
	
	#############################
	
	msg.corpus <- Corpus(VectorSource(msg))
	
	# Hard-coded TDM control
	control <- list(stopwords = TRUE,
			removePunctuation = TRUE,
			removeNumbers = TRUE)
	msg.tdm <- TermDocumentMatrix(msg.corpus, control)
	word.freq <- rowSums(as.matrix(msg.tdm))
	
	word.freq <- word.freq[which(word.freq >= 1)]

	for(j in 1:length(t)) {
		t[j] <- 0
	}

	for(j in 1:length(word.freq)) {
		if(length(which(names(word.freq[j]) == term_list_from_spam_and_ham))) {
			t[which(names(word.freq[j]) == term_list_from_spam_and_ham)] <- as.numeric(word.freq[j])
		}
	}

	corpus <- rbind(corpus, t)
}

corpus <- corpus[2:nrow(corpus),]
corpus_modify <- corpus[1:(length(spam.docs) + length(easyham.docs)),]

names <- c(spam.docs, easyham.docs)

rownames(corpus_modify) <- names
colnames(corpus_modify) <- term_list_from_spam_and_ham

# idx <- 1
# delete_col <- c()

# for(i in 1:ncol(corpus_modify)) {
# 	if(mean(corpus_modify[,i]) < 0.01) {
# 	delete_col[idx] <- i
# 	idx <- idx + 1
# 	}
# }

# corpus_modify2 <- corpus_modify[,-delete_col]

write.csv(corpus_modify, paste("tmp_", CORPUS_NAME, ".csv", sep=""))

dtm <- corpus_modify

# dtm[�t�@�C����,�P�ꐔ]

idx <- 1
delete_col <- c()

min_value_from_df <- mean( min(spam.df$occurrence), min(easyham.df$occurrence))
# min_value_from_df <- 0.15

# 16151
for(i in 2:ncol(dtm)) {
	# Occurrence ��, spam.df �� easyham.df ���� �P��̏o���p�x�̍Œ�l�̕��ϖ����̒P�������
	if( (length(which(dtm[,i]>=1)) / length(dtm[,1]) ) <  min_value_from_df) {
		delete_col[idx] <- i
		idx <- idx + 1
	}
}

dtm2 <- dtm[,-delete_col]

write.csv(dtm2, paste(CORPUS_NAME, ".csv", sep=""))

 