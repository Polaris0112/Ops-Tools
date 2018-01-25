#--coding:utf-8--
import urllib2
import json
import sys

corpid = ""
aid_sct={
         "agentid":"app-secert",
        }


def towechat(content,agentid=1):
    reload(sys)
    sys.setdefaultencoding('utf8')

    #获取access_token
    GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s" % (corpid , aid_sct[str(agentid)])
    result=urllib2.urlopen(urllib2.Request(GURL)).read()
    dict_result = json.loads(result.decode('utf-8'))
    Gtoken=dict_result['access_token']

    #生成通过post请求发送消息的url
    PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s" % Gtoken

    #企业号中的应用id
    AppID=agentid
    #部门成员id，微信接收者
    UserID="@all"

    #生成post请求信息
    post_data = {}
    msg_content = {}
    try:
        msg_content['content'] = content.encode("utf-8").replace("\u001b","").replace("[31m","").replace("[37m","")
    except UnicodeDecodeError:
        msg_content['content'] = content
    post_data['touser'] = UserID
    post_data['msgtype'] = 'text'
    post_data['agentid'] = AppID
    post_data['text'] = msg_content
    post_data['safe'] = '0'
    #由于字典格式不能被识别，需要转换成json然后在作post请求
    #注：如果要发送的消息内容有中文的话，第三个参数一定要设为False
    json_post_data = json.dumps(post_data,ensure_ascii=False)

    print json_post_data
    #通过urllib2.urlopen()方法发送post请求
    request_post = urllib2.urlopen(PURL, json_post_data)
    #read()方法查看请求的返回结果
    res=json.loads(request_post.read().replace("'","\""))
    if res['errcode']==0:
        return True
    elif res['errcode']==40033:
        print("send frequency over limit.")
    else:
        print("send failed, error message : {0}, error code : {1}".format(res['errmsg'], res['errcode']))
    return False


if __name__ == '__main__':
    pass
 
