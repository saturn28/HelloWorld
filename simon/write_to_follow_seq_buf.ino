/*******************************************************************************
* write_to_follow_seq_buf.ino
* Author: Jeff Crockett
* Date 01/04/15
* Rev A
* Description:
* This fuction handles the writing of the random data to the sequence buffer
* which the user will follow.
*******************************************************************************/
void write_to_follow_seq_buf (unsigned int wptr[], int rndata, boolean clr_index) {
    static int wptr_ctr;
    if (clr_index == 1) {
      wptr_ctr = 0;
    }
    if (wptr_ctr < 32) {
      wptr[wptr_ctr] = rndata;
      Serial.println(wptr_ctr,DEC);
      wptr_ctr++;
    }
}
