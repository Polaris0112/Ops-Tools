## 企业微信应用通知接口

### 使用介绍

此工具是企业微信应用的通知接口（群发消息）

-  `send_qyweixin.py`：基于`python`语言编写，首先填入第6行`corpid`企业微信的企业id，7-9行的`json`是`agentid`应用`id`作为`key`，值`value`是`agentid`对应的`app-secret`，这几个参数在企业微信的管理员后台可以查询到。调用方法：
```python
from send_qyweixin import towechat

send_content = "test data"
agent_id = 6

towechat(send_content, agent_id)

```

只能发文本信息

-  `send_qyweixin.sh`：跟py的一样，修改`CropID`和`Secret`改成对应的企业生成的密码和app生成的密码即可。


