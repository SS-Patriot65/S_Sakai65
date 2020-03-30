##################################
# �ړI : SpamAssassin��p�����Ƃ���eLSNB�̎��s��. ����ł͕K�v�Ȃ�����. 
# �\�[�X�R�[�h�� : Classifier_LSNB_New_for_SA.R
# �o�[�W���� : SR(1)
# �ŏI�ύX���� : 2017.06.08, 16:59
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

  match.probs <- 0.0
  num_not_match <- 0

  # �N���X1�Ƌ��N����P��𒊏o����
  msg.match_tr <- intersect(names(msg.freq), training.df$term)
  
  # �N���X2�Ƌ��N����P��𒊏o����
  msg.match_cp <- intersect(names(msg.freq), counterpart.df$term)

  {
  # 2�̃N���X�̂ǂ���ł����N���Ȃ������ꍇ�AP(mail|class)=c^�P�ꐔ
  if((length(msg.match_tr) + length(msg.match_cp)) < 1)
  {
    return(log(prior) + log(c) * (length(msg.freq)))
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
          as.a <- training.df$occurrence[idx_tr] * training.df$density[idx_tr]
	    as.b <- (1.0 - training.df$occurrence[idx_tr]) * c
	    as.c <- c * c
	    as.d <- (1.0 - c) * training.df$density[idx_tr]

	    if(as.a == 0.0) as.a <- c
	    if(as.b == 0.0) as.b <- c
	    if(as.c == 0.0) as.c <- c
	    if(as.d == 0.0) as.d <- c

	    tmp_occ <- calculate.LS(as.a, as.b, as.c, as.d)
	    match.probs <- match.probs + log(tmp_occ)
      }

	# �N���X2�݂̂Ō�������
	else if(is.na(idx_tr) && is.na(idx_cp)==F)
      {
          as.a <- c * c
	    as.b <- (1.0 - c) * counterpart.df$density[idx_cp]
	    as.c <- counterpart.df$occurrence[idx_cp] * counterpart.df$density[idx_cp]
	    as.d <- (1.0 - counterpart.df$occurrence[idx_cp]) * c

	    if(as.a == 0.0) as.a <- c
	    if(as.b == 0.0) as.b <- c
	    if(as.c == 0.0) as.c <- c
	    if(as.d == 0.0) as.d <- c

	    tmp_occ <- calculate.LS(as.a, as.b, as.c, as.d)
	    match.probs <- match.probs + log(tmp_occ)
      }

	# �����Ƃ��Ō�������
	else
	{
	    as.a <- training.df$occurrence[idx_tr] * training.df$density[idx_tr]
	    as.b <- (1.0 - training.df$occurrence[idx_tr]) * counterpart.df$density[idx_cp]
	    as.c <- counterpart.df$countPos[idx_cp] * counterpart.df$density[idx_cp]
	    as.d <- (1.0 - counterpart.df$occurrence[idx_cp]) * training.df$density[idx_tr]

	    if(as.a == 0.0) as.a <- c
	    if(as.b == 0.0) as.b <- c
	    if(as.c == 0.0) as.c <- c
	    if(as.d == 0.0) as.d <- c

	    tmp_occ <- calculate.LS(as.a, as.b, as.c, as.d)
	    match.probs <- match.probs + log(tmp_occ)
	}
	}
    }

    # �A���_�[�t���[��h�� 
    if(num_not_match >= (MIN_DEC+1))
    {
	  num_not_match = MIN_DEC
    }

    return_value <- log(prior) + match.probs + (log(c) * num_not_match)
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