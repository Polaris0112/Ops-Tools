#!/usr/bin/env python

import smtplib, email.mime.multipart, email.mime.text

def send():
    msg=email.mime.multipart.MIMEMultipart()
    msg['from']="xxx@gmail.com"
    msg['to']=','.join(["xxx@gmail.com","xxxx2@gmail.com"])
    msg['subject']="test"
    content="data"
    txt=email.mime.text.MIMEText(content)
    msg.attach(txt)

    smtp=smtplib
    smtp=smtplib.SMTP()
    smtp.connect("smtp.exmail.qq.com",25)
    smtp.login("xxxx@gmail.com","xxxxx")
    smtp.sendmail("xxx@gmail.com",["xxx@gmail.com","xxx@gmail.com"],str(msg))
    smtp.quit()

send()

