##################################
# �ړI : SR �p�v���O����
# �\�[�X�R�[�h�� : Read_dtm.R
# �o�[�W���� : SR(1)
# �ŏI�ύX���� : 2017.05.31, 11:36
# �쐬�� : Taniguchi Hidetaka
##################################

{
if(CORPUS_NAME == "pizza") {
	load(file.path('dtm.RData'))
}

else {
	dtm <- read.csv(paste(CORPUS_NAME, ".csv", sep=""))
	# dtm <- read.csv(paste("tmp.csv", sep=""))
}
}

 