##################################
# �ړI : main�t�@�C��. ��������s����Ǝ������J�n�����. ���ʂ̕ۑ������̃v���O�����ōs��. 
# �\�[�X�R�[�h�� : main.R
# �o�[�W���� : SR(2)
# �ŏI�ύX���� : 2017.06.11, 19:19
# �쐬�� : Taniguchi Hidetaka
##################################

library('tm')
library('ggplot2')

setwd("C:\\Users\\V\\Desktop\\spam_classifier\\src")
(getwd())

# ���p����R�[�p�X��
CORPUS_NAME <- "ling"
df_skew <- FALSE

# NB, LSNB, eLSNB�œ����������肷��ꍇ�̗�
if(df_skew == TRUE) {
	df_skewed_number <- 10
}

# ���񎎍s���邩
ITERATION <- 6

# �e��ŁA���x�v���O�������񂷂�
LOOP_COUNTER <- 50

# �e�t�@�C������A����P�ꂪN��ȏ�ϑ����ꂽ�ꍇ�A�P�ꕶ�͍s��ɉ�����
MIN_DOC_FREQ_N <- 2

corpus_length_spam <- -1
corpus_length_ham <- -1

if(CORPUS_NAME == "enron") {
	corpus_length_spam <- 1496
	corpus_length_ham <- 4360
}

if(CORPUS_NAME == "ling") {
	corpus_length_spam <- 470
	corpus_length_ham <- 2400
}

if(CORPUS_NAME == "sa") {
	corpus_length_spam <- 492
	corpus_length_ham <- 2442
}

# �e�X�g�f�[�^�̐�
NUMBER_OF_TEST_DATA_HAM <- (corpus_length_ham / 2)
NUMBER_OF_TEST_DATA_SPAM <- (corpus_length_spam / 2)

# NUMBER_OF_TEST_DATA_HAM <- 2
# NUMBER_OF_TEST_DATA_SPAM <- 2

# ���O�m��
PRIOR_NB_SPAM <- 0.500
PRIOR_NB_HAM <- (1.000 - PRIOR_NB_SPAM)

# ���m��ɑ΂���m���ݒ�
ccc <- 1e-6

# Set the global paths
source('path.R')

# NB�̌���
result_NB <- list()
result_LSNB <- list()
result_LSNB_New <- list()

result_SVM <- list()
result_KSVM <- list()
result_NN <- list()
result_LoRe <- list()
result_RR <- list()

cnt_i <- 1
cnt_j <- 1

# �f�[�^�̊Ԋu
HAM_SPARSITY <- 40

# �g�p����n���f�[�^�̏����l
HAM_FROM <- 40

# �n���ɑ΂��āA�X�p���̃f�[�^���ǂꂾ���g����
SPAM_RATIO <- (1/1)

# Ham �Œ�p
# SPAM_SPARSITY <- 40
# SPAM_FROM <- 40
# HAM_RATIO <- (1/1)

for(cnt_i in 1:ITERATION)
{
	# �w�K�Ɏg�����t�f�[�^�̐����X�V����
 	# NUM_SUPERVISE_DATASETS_EASYHAM <- HAM_FROM + (HAM_SPARSITY * (cnt_i-1))
	# NUM_SUPERVISE_DATASETS_SPAM <- (NUM_SUPERVISE_DATASETS_EASYHAM * SPAM_RATIO)

	# Spam �Œ�p
 	NUM_SUPERVISE_DATASETS_EASYHAM <- HAM_FROM + (HAM_SPARSITY * (cnt_i-1))
	NUM_SUPERVISE_DATASETS_SPAM <- 50

	# Ham �Œ�p
 	# NUM_SUPERVISE_DATASETS_EASYHAM <- 50
	# NUM_SUPERVISE_DATASETS_SPAM <- SPAM_FROM + (SPAM_SPARSITY * (cnt_i-1))

	# �����V���b�g
	# NUM_SUPERVISE_DATASETS_EASYHAM <- 1
	# NUM_SUPERVISE_DATASETS_SPAM <- 1

	# �R�[�p�X�쐬�p
	# NUM_SUPERVISE_DATASETS_EASYHAM <- corpus_length_ham - 2
	# NUM_SUPERVISE_DATASETS_SPAM <- corpus_length_spam - 2

	NUM_SUPERVISE_DATASETS_TOTAL <- (NUM_SUPERVISE_DATASETS_EASYHAM + NUM_SUPERVISE_DATASETS_SPAM)

	# �v���O�������s��
	for(cnt_j in 1:LOOP_COUNTER)
	{
		# ���ފ�錾
		source('Classifier.R')
		source('Classifier_LS.R')
	
		# ���t�f�[�^�̓ǂݍ��݂ƁA�P�ꕶ�͍s��̐���
		source('Training.R')

		# ���ފ�̍Đݒ�
		source('Test.R')

		# LS�̍Đݒ�
		source('New_NB_Classifier.R')
		source('New_LS.R')
		source('Test_LS.R')

		{
		if(CORPUS_NAME == "sa") { 
			source('Classifier_LSNB_New_for_SA.R')
		}

		else {
			source('Classifier_LSNB_New.R')
		}
		}

		source('Test_LS_New.R')

		if(CORPUS_NAME != "pizza") {
			if(cnt_i == 1 && cnt_j == 1) {
				source('Read_dtm.R')
			}
		}

		else {
			source('Read_dtm.R')
		}

		# �T�|�[�g�x�N�^�[�}�V��(SVM)
		source("chapter12.R")
		print("--------------")

		# �T�|�[�g�x�N�^�[�}�V��(KSVM)
		source("ksvm.R")
		print("--------------")

		# �j���[�����l�b�g���[�N(NN)
		source("NNET.R")
		print("--------------")

		# ���W�X�e�B�b�N��A(LoRe)
		source("Logistic_Regression.R")
		print("--------------")

		# �����_���t�H���X�g(RR)
		source("Random_Forest.R")
		print("--------------")

		# �N���A�֐�
		source('Clear.R')

		print("--------------")
	}

	# NB�̌��ʂ��L�^����
	result_matrix_NB <- data.frame(result_NB)
	result_matrix_NB <- t(result_matrix_NB)
	result_NB_name <- paste(CORPUS_NAME, "_results//NB//", CORPUS_NAME, "_NB_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_NB, result_NB_name, sep=",", col.names=F, row.names=F, append=T)

	# LSNB�̌��ʂ��L�^����
	result_matrix_LSNB <- data.frame(result_LSNB)
	result_matrix_LSNB <- t(result_matrix_LSNB)
	result_LSNB_name <- paste(CORPUS_NAME, "_results//LSNB//", CORPUS_NAME,"_LSNB_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_LSNB, result_LSNB_name, sep=",", col.names=F, row.names=F, append=T)

	# LSNB_New�̌��ʂ��L�^����
	result_matrix_LSNB_New <- data.frame(result_LSNB_New)
	result_matrix_LSNB_New <- t(result_matrix_LSNB_New)
	result_LSNB_New_name <- paste(CORPUS_NAME, "_results//LSNB_New//", CORPUS_NAME, "_LSNB_New_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_LSNB_New, result_LSNB_New_name, sep=",", col.names=F, row.names=F, append=T)

	# SVM�̌��ʂ��L�^����
	result_matrix_SVM <- data.frame(result_SVM)
	result_matrix_SVM <- t(result_matrix_SVM)
	result_SVM_name <- paste(CORPUS_NAME, "_results//SVM//", CORPUS_NAME, "_SVM_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_SVM, result_SVM_name, sep=",", col.names=F, row.names=F, append=T)

	# KSVM�̌��ʂ��L�^����
	result_matrix_KSVM <- data.frame(result_KSVM)
	result_matrix_KSVM <- t(result_matrix_KSVM)
	result_KSVM_name <- paste(CORPUS_NAME, "_results//KSVM//", CORPUS_NAME, "_KSVM_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_KSVM, result_KSVM_name, sep=",", col.names=F, row.names=F, append=T)

	# NN�̌��ʂ��L�^����
	result_matrix_NN <- data.frame(result_NN)
	result_matrix_NN <- t(result_matrix_NN)
	result_NN_name <- paste(CORPUS_NAME, "_results//NN//", CORPUS_NAME, "_NN_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_NN, result_NN_name, sep=",", col.names=F, row.names=F, append=T)

	# LoRe�̌��ʂ��L�^����
	result_matrix_LoRe <- data.frame(result_LoRe)
	result_matrix_LoRe <- t(result_matrix_LoRe)
	result_LoRe_name <- paste(CORPUS_NAME, "_results//LoRe//", CORPUS_NAME, "_LoRe_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_LoRe, result_LoRe_name, sep=",", col.names=F, row.names=F, append=T)

	# RR�̌��ʂ��L�^����
	result_matrix_RR <- data.frame(result_RR)
	result_matrix_RR <- t(result_matrix_RR)
	result_RR_name <- paste(CORPUS_NAME, "_results//RR//", CORPUS_NAME, "_RR_", "h", NUM_SUPERVISE_DATASETS_EASYHAM, "_", "s", NUM_SUPERVISE_DATASETS_SPAM, "(hp", PRIOR_NB_HAM, ",hs", PRIOR_NB_SPAM, ")", ".csv", sep="")
	write.table(result_matrix_RR, result_RR_name, sep=",", col.names=F, row.names=F, append=T)
}

 