##################################
# �ړI : �N���A�֐�. �����[�v���ƂɊJ���������ϐ������݂��邪, �����ł́u�J���������Ȃ��ϐ��v���`��, ����ȊO�̕ϐ���S�ĊJ������. 
# �\�[�X�R�[�h�� : Clear.R
# �o�[�W���� : SR(2)
# �ŏI�ύX���� : 2017.06.11, 18:51
# �쐬�� : Taniguchi Hidetaka
##################################

# �v���O�����̃N���A�����A�����őS�Ă̕ϐ����������

# �錾���ꂽ�S�Ă̕ϐ��̖��O���L�^����
rm_list <- ls()

# ������"�J�����Ȃ��ϐ��̖��O"���w�肷��
rm_list <- rm_list[rm_list != c("rm_list")]

rm_list <- rm_list[rm_list != c("CORPUS_NAME")]
rm_list <- rm_list[rm_list != c("df_skew")]
rm_list <- rm_list[rm_list != c("df_skewed_number")]

rm_list <- rm_list[rm_list != c("ITERATION")]
rm_list <- rm_list[rm_list != c("LOOP_COUNTER")]
rm_list <- rm_list[rm_list != c("HAM_SPARSITY")]
rm_list <- rm_list[rm_list != c("HAM_FROM")]
rm_list <- rm_list[rm_list != c("HAM_RATIO")]
rm_list <- rm_list[rm_list != c("SPAM_SPARSITY")]
rm_list <- rm_list[rm_list != c("SPAM_FROM")]
rm_list <- rm_list[rm_list != c("SPAM_RATIO")]
rm_list <- rm_list[rm_list != c("MIN_DOC_FREQ_N")]

rm_list <- rm_list[rm_list != c("PRIOR_NB_SPAM")]
rm_list <- rm_list[rm_list != c("PRIOR_NB_HAM")]
rm_list <- rm_list[rm_list != c("PRIOR_LSNB_SPAM")]
rm_list <- rm_list[rm_list != c("PRIOR_LSNB_HAM")]
rm_list <- rm_list[rm_list != c("PRIOR_eLSNB_SPAM")]
rm_list <- rm_list[rm_list != c("PRIOR_eLSNB_HAM")]
rm_list <- rm_list[rm_list != c("ccc")]

rm_list <- rm_list[rm_list != c("spam.path")]
rm_list <- rm_list[rm_list != c("easyham.path")]
rm_list <- rm_list[rm_list != c("hardham.path")]

# ���ʂ͂����������Ȃ�
rm_list <- rm_list[rm_list != c("result_NB")]
rm_list <- rm_list[rm_list != c("result_LSNB")]
rm_list <- rm_list[rm_list != c("result_LSNB_New")]
rm_list <- rm_list[rm_list != c("result_SVM")]
rm_list <- rm_list[rm_list != c("result_KSVM")]
rm_list <- rm_list[rm_list != c("result_NN")]
rm_list <- rm_list[rm_list != c("result_LoRe")]
rm_list <- rm_list[rm_list != c("result_RR")]

rm_list <- rm_list[rm_list != c("cnt_i")]
rm_list <- rm_list[rm_list != c("cnt_j")]

rm_list <- rm_list[rm_list != c("dtm")]

rm_list <- rm_list[rm_list != c("corpus_length_ham")]
rm_list <- rm_list[rm_list != c("corpus_length_spam")]

rm_list <- rm_list[rm_list != c("NUM_SUPERVISE_DATASETS_EASYHAM")]
rm_list <- rm_list[rm_list != c("NUM_SUPERVISE_DATASETS_SPAM")]
rm_list <- rm_list[rm_list != c("NUM_SUPERVISE_DATASETS_TOTAL")]

rm_list <- rm_list[rm_list != c("NUMBER_OF_TEST_DATA_HAM")]
rm_list <- rm_list[rm_list != c("NUMBER_OF_TEST_DATA_SPAM")]

# �e�X�g�f�[�^�͕s�ςȂ̂ŏ����Ȃ�
rm_list <- rm_list[rm_list != c("easyham2.docs")]
rm_list <- rm_list[rm_list != c("hardham2.docs")]
rm_list <- rm_list[rm_list != c("spam2.docs")]

# �ꕔ�������S�Ă̕ϐ����������
rm(list=rm_list)

 