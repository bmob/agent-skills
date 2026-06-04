  // session 会话id，可以传用户objectId，或者随机数
  // content 内容，提问的内容，如果希望上下文，可以这样传入
  // {"model":"gpt-3.5-turbo","messages":[{"content":"你好","role":"user"},{"content":"你好，有什么我可以为你提供的帮助吗？","role":"assistant"},{"content":"请问Bmob是什么产品","role":"user"}]}

let data = {"messages":[{"content":"你好","role":"user"}],"session":"b1"}
ChatAi.send(JSON.stringify(data))