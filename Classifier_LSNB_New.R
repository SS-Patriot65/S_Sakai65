##################################
# �ړI : eLSNB�̎��s��. 
# �\�[�X�R�[�h�� : Classifier_LSNB_New.R
# �o�[�W���� : SR(1)
# �ŏI�ύX���� : 2017.06.08, 16:57
# �쐬�� : Taniguchi Hidetaka
##################################

# LSNB
classify_LSNB_New.email <- function(path, training.df, counterpart.df, prior, c = ccc)
{
  msg <- get.msg(path)
  msg.tdm <- get.tdm(msg)
  msg.matrix <- as.matrix(msg.tdm)
  msg.freq <- rowSums(msg.matrix)

  # 1e-323�������ƃA���_�[�t���[���Ă��܂��̂ŁA���̑O�ɉ����l�����߂Ă���
  MIN_DEC <- 40

  match.probs <- 1.0
  num_not_match <- 0

  # �N���X1�Ƌ��N����P��𒊏o����
  msg.match_tr <- intersect(names(msg.freq), training.df$term)
  
  # �N���X2�Ƌ��N����P��𒊏o����
  msg.match_cp <- intersect(names(msg.freq), counterpart.df$term)

  {
  # 2�̃N���X�̂ǂ���ł����N���Ȃ������ꍇ�AP(mail|class)=c^�P�ꐔ
  if((length(msg.match_tr) + length(msg.match_cp)) < 1)
  {
    return(prior * c ^ (length(msg.freq)))
  }

  else
  {
    # path����ǂݍ��񂾃t�@�C���Q����ɁA�f�[�^�t���[���𐶐�����
    msg.df <- data.frame(cbind(names(msg.freq),
                          as.numeric(msg.freq)),
                    stringsAsFactors = FALSE)
    names(msg.df) <- c("term", "frequency")
    msg.df$frequency <- as.numeric(msg.df$frequency)

    # path���������f�[�^�t���[���Ɋ܂܂��P����m�F����
    for(i in 1:nrow(msg.df))
    {
      # �N���X1�Ƌ��N���邩�𒲂ׁA���N����ΊY�����镨��training.df$term�ł̒ʂ��ԍ����L�^
      idx_tr <- match(msg.df$term[i], training.df$term)
      idx_cp <- match(msg.df$term[i], counterpart.df$term)

	{
	# ����P�ꂪ2�̃N���X�����Ō�����Ȃ�����
      if(is.na(idx_tr) && is.na(idx_cp))
      {
	    num_not_match <- num_not_match + 1
      }

	# �N���X1�݂̂Ō�������
	else if(is.na(idx_tr)==F && is.na(idx_cp))
      {
          as.a <- training.df$countPos[idx_tr] * training.df$density[idx_tr]
	    as.b <- training.df$countNeg[idx_tr] * c
	    as.c <- c * c
	    as.d <- (1.0 - c) * training.df$density[idx_tr]

	    tmp_occ <- calculate.LS(as.a, as.b, as.c, as.d)
	    match.probs <- match.probs * tmp_occ
      }

	# �N���X2�݂̂Ō�������
	else if(is.na(idx_tr) && is.na(idx_cp)==F)
      {
          as.a <- c * c
	    as.b <- (1.0 - c) * counterpart.df$density[idx_cp]
	    as.c <- counterpart.df$countPos[idx_cp] * counterpart.df$density[idx_cp]
	    as.d <- counterpart.df$countNeg[idx_cp] * c

	    tmp_occ <- calculate.LS(as.a, as.b, as.c, as.d)
	    match.probs <- match.probs * tmp_occ
      }

	# �����Ƃ��Ō�������
	else
	{
	    as.a <- training.df$countPos[idx_tr] * training.df$density[idx_tr]
	    as.b <- training.df$countNeg[idx_tr] * counterpart.df$density[idx_cp]
	    as.c <- counterpart.df$countPos[idx_cp] * counterpart.df$density[idx_cp]
	    as.d <- counterpart.df$countNeg[idx_cp] * training.df$density[idx_tr]

	    tmp_occ <- calculate.LS(as.a, as.b, as.c, as.d)
	    match.probs <- match.probs * tmp_occ
	}
	}
    }

    # �A���_�[�t���[��h�� 
    if(num_not_match >= (MIN_DEC+1))
    {
	  num_not_match = MIN_DEC
    }

    # print(prior * match.probs * (c ^ num_not_match))

    return_value <- prior * match.probs * (c ^ num_not_match)

    if(is.na(return_value) == TRUE)
    {
        return_value <- 1e-320
    }

    # print(return_value)

    if(return_value <= 1e-320)
    {
        return_value <- 1e-320
    }

    return(return_value)
  }
  }
}

# LSNB�̎��s��
spam.classifier_LSNB <- function(path)
{
  pr.spam <- classify_LSNB_New.email(path, spam.df, easyham.df, PRIOR_NB_SPAM)
  pr.ham <- classify_LSNB_New.email(path, easyham.df, spam.df, PRIOR_NB_HAM)
  return(c(pr.spam, pr.ham, ifelse(pr.spam > pr.ham, 1, 0)))
}