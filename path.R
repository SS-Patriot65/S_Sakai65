##################################
# �ړI : ���t�f�[�^����уe�X�g�f�[�^�����݂���f�B���N�g�̃p�X���`����. 
# �\�[�X�R�[�h�� : path.R
# �o�[�W���� : SR(1)
# �ŏI�ύX���� : 2017.06.08, 16:58
# �쐬�� : Taniguchi Hidetaka
##################################

# �t�@�C���̂��鑊�΃A�h���X���w�肷��
spam.path <- file.path(paste(CORPUS_NAME, "_data", sep=""), "spam")
easyham.path <- file.path(paste(CORPUS_NAME, "_data", sep=""), "ham")

if(CORPUS_NAME == "sa") {
	hardham.path <- file.path("data", "hard_ham")
	hardham.docs <- dir(hardham.path)
	hardham.docs <- hardham.docs[which(hardham.docs != "cmds")]
}
 