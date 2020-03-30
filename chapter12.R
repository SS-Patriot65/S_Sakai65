##################################
# �ړI : SVM���s�v���O����. �܂�, NN�ȂǂŎg���f�[�^�t���[���������ō��. 
# �\�[�X�R�[�h�� : chapter12.R
# �o�[�W���� : SR(1)
# �ŏI�ύX���� : 2017.06.08, 16:57
# �쐬�� : Taniguchi Hidetaka
##################################

library('e1071')

# Eleventh code snippet
# load(file.path('dtm.RData'))

##########################

training_data_mix.docs <- c(spam.docs, easyham.docs)
training_data_mix.docs <- sort(training_data_mix.docs)

head(training_data_mix.docs)

{
if(CORPUS_NAME == "pizza") {
	# �S�f�[�^����ANB�̋��t�f�[�^�Ƃ��Ďg��ꂽ���̂Ɠ����t�@�C�����̂��݂̂̂𒊏o����
	training_dtm <- dtm[which(is.na(match(rownames(dtm), training_data_mix.docs))==FALSE),]
	head(sort(rownames(training_dtm)))
}

else {
	# �S�f�[�^����ANB�̋��t�f�[�^�Ƃ��Ďg��ꂽ���̂Ɠ����t�@�C�����̂��݂̂̂𒊏o����
	training_dtm <- dtm[which(is.na(match(dtm$X, training_data_mix.docs))==FALSE),]
	# head(sort(rownames(training_dtm)))
}
}

# ���t�f�[�^��
length(training_dtm[,1])

# �ǂݍ��܂ꂽ�S�f�[�^��
length(dtm[,1])

# �S�f�[�^�ihardham�������j�ɂ́A�X�p��481�ʁA�C�[�W�[�n��2412�ʂ̏��Ɋi�[����Ă���B
# ���̂��߁Ay�ɐ擪��500�ʂ̃��[���̃X�p���N���X�Ƃ��Ċi�[���A���̑��̓n���N���X�Ƃ���
y <- c(1:length(dtm[,1]))

for(i in 1 : length(y))�@{
	{if(i <= corpus_length_spam)�@{
			y[i] <- 1
	}
	else�@{
			y[i] <- 0
	}}
}

##########
test_data_mix.docs <- c(spam2.docs, easyham2.docs)
test_data_mix.docs <- sort(test_data_mix.docs)

{
if(CORPUS_NAME == "pizza") {
	# �S�f�[�^�̒�����A���t�f�[�^�Ɋ܂܂�Ȃ��������̂��X�ɒ��o���A�e�X�g�f�[�^�Ƃ���
	test_dtm <- dtm[which(is.na(match(rownames(dtm), test_data_mix.docs))==FALSE),]
	# head(sort(rownames(test_dtm)))
}

else {
	# �S�f�[�^�̒�����A���t�f�[�^�Ɋ܂܂�Ȃ��������̂��X�ɒ��o���A�e�X�g�f�[�^�Ƃ���
	test_dtm <- dtm[which(is.na(match(dtm$X, test_data_mix.docs))==FALSE),]
	# head(sort(rownames(test_dtm)))
}
}

# �e�X�g�f�[�^��
length(test_dtm[,1])

###########

{
if(CORPUS_NAME == "pizza") {
	# ���t�f�[�^���i�t�@�C�����j * �P�ꐔ�̍s������
	train.x <- dtm[which(is.na(match(rownames(dtm), rownames(training_dtm)))==FALSE), 3:ncol(training_dtm)]

	# ���t�f�[�^�� * ���t�f�[�^�̃N���X�̃x�N�g�������
	train.y <- y[which(is.na(match(rownames(dtm), rownames(training_dtm)))==FALSE)]
	names(train.y) <- rownames(training_dtm)

	# �e�X�g�f�[�^���i�t�@�C�����j * �P�ꐔ�̍s������
	test.x <- dtm[which(is.na(match(rownames(dtm), rownames(test_dtm)))==FALSE), 3:ncol(test_dtm)]

	# �e�X�g�f�[�^�� * �e�X�g�f�[�^�̃N���X�̃x�N�g�������
	test.y <- y[which(is.na(match(rownames(dtm), rownames(test_dtm)))==FALSE)]
	names(test.y) <- rownames(test_dtm)
}

else {
	# ���t�f�[�^���i�t�@�C�����j * �P�ꐔ�̍s������
	train.x <- dtm[which(is.na(match(dtm$X, training_dtm$X))==FALSE), 3:ncol(training_dtm)]

	# ���t�f�[�^�� * ���t�f�[�^�̃N���X�̃x�N�g�������
	train.y <- y[which(is.na(match(dtm$X, training_dtm$X))==FALSE)]
	names(train.y) <- training_dtm$X

	# �e�X�g�f�[�^���i�t�@�C�����j * �P�ꐔ�̍s������
	test.x <- dtm[which(is.na(match(dtm$X, test_dtm$X))==FALSE), 3:ncol(test_dtm)]

	# �e�X�g�f�[�^�� * �e�X�g�f�[�^�̃N���X�̃x�N�g�������
	test.y <- y[which(is.na(match(dtm$X, test_dtm$X))==FALSE)]
	names(test.y) <- test_dtm$X
}
}

head(sort(rownames(test.x)))

# is.na(match(names(dtm[,1]), names(test.y))==TRUE)
# which(match(names(dtm[,1]), names(train.y))==TRUE)

# rm(dtm)

# �ǂݍ��񂾋��t�f�[�^�̐�(�X�p��)
length(train.y[which(train.y==1)])
# �ǂݍ��񂾋��t�f�[�^�̐�(�n��)
length(train.y[which(train.y==0)])

# �ǂݍ��񂾃e�X�g�f�[�^�̐�(�X�p��)
length(test.y[which(test.y==1)])
# �ǂݍ��񂾃e�X�g�f�[�^�̐�(�n��)
length(test.y[which(test.y==0)])

###########################################

train_df.x <- data.frame(train.x)
train_df.x$ZSpecies <- train.y
names(train_df.x$ZSpecies) <- "ZSpecies"

test_df.x <- data.frame(test.x)
test_df.x$ZSpecies <- test.y
names(test_df.x$ZSpecies) <- "ZSpecies"

train_df.x$ZSpecies <- cut(train_df.x$ZSpecies, c(0, 0.5, 1.0), labels=c("ham", "spam"), right=FALSE)
test_df.x$ZSpecies <- cut(test_df.x$ZSpecies, c(0, 0.5, 1.0), labels=c("ham", "spam"), right=FALSE)

svm.kernel_type <- "radial"

# SVM, ���`�J�[�l��
svm.fit <- svm(ZSpecies~., data=train_df.x, scale=FALSE, kernel=svm.kernel_type, cost=0.1)

# Seventeenth code snippet
svm.predictions <- predict(svm.fit, test_df.x)

svm.predictions.spam_results <- svm.predictions[1:length(test.y[which(test.y==1)])]
test_class_spam <- test_df.x$ZSpecies[1:length(test.y[which(test.y==1)])]
svm.spam_accuracy <- length(svm.predictions.spam_results[which(svm.predictions.spam_results == test_class_spam)]) / length(svm.predictions.spam_results)

svm.predictions.ham_results <- svm.predictions[(length(test_class_spam)+1):length(test.y[which(test.y==0)])]
test_class_ham <- test_df.x$ZSpecies[(length(test_class_spam)+1):length(test.y[which(test.y==0)])]
svm.ham_accuracy <- length(svm.predictions.ham_results[which(svm.predictions.ham_results == test_class_ham)]) / length(svm.predictions.ham_results)

# 
svm.result <- length(svm.predictions[which(svm.predictions == test_df.x$ZSpecies)]) / length(svm.predictions)

result_SVM[[cnt_j]] <- c(svm.spam_accuracy, svm.ham_accuracy)

print(paste("svm:", svm.kernel_type, sep=""))
print(svm.spam_accuracy)
print(svm.ham_accuracy)

 