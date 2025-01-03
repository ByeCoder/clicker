local tdlua = require "tdlua"
math.randomseed(os.clock()*100000000000)
tabist = arg[1]
islogging = arg[2] or 0
base = {}
json = dofile('./dkjson.lua')
dbst = (loadfile "./redis.lua")()
nump = 0
tdst = {}
bot = dbst:get(tabist.."botid") or "123456789"
main = {}
comm = {}
defa = {}
RC = false
start=true
require("socket")
http = require('socket.http')
local function dl_cb(arg, data) end 
local yes, configdata = pcall(require,  "data/clicker-"..tabist.."/configdata")
function vardump(wut) end
local isnew = false
tdlua.setLogLevel(0)
local client = tdlua()
local clock = os.clock
local function sleep(n) local t0 = clock() while clock() - t0 <= n do end end
client:send(({ ["@type"] = 'addProxy', server = "127.0.0.1", port = 9050 + tonumber(tabist),enable = true ,type ={["@type"] = 'proxyTypeSocks5',username = nil,password =nil } } ))
client:send(({["@type"] = "getAuthorizationState"}))
local ready = false 
local function authstate(state) if state["@type"] == "authorizationStateClosed" then return true elseif state["@type"] == "authorizationStateWaitTdlibParameters" then  if configdata.api_id == nil then print("✔️You are creating config of Clicker number "..tabist) print("1️⃣ Please enter API_ID(from my.telegram.org):") 
if dbst:get("APIID") then api_id = dbst:get("APIID") else api_id = io.read() end print("2️⃣️⃣ Please enter HASH_ID(from my.telegram.org):") 
if dbst:get("APIHASH") then api_hash = dbst:get("APIHASH") else api_hash = io.read() end local system_language_code = "en" print("3️⃣️⃣️⃣ Please enter Device_Model(from every real session):") local device_model = "LGE Nexus 5" print("4️⃣️⃣️⃣️⃣ Please enter System_Version(from every real session):") local system_version = "9 P (28)" local application_version = "4.9.1" isentered = true function save_data(filename, data) noload = true local f = io.open(filename, 'w') f:write(data) f:close() noload = false end function load_data(filename) local f = io.open(filename) if not f then return {} end local s = f:read('*all') f:close() return s end os.execute("mkdir -p data") os.execute("mkdir -p data/clicker-"..tabist) local cdata = load_data("./data/clicker-"..tabist.."/configdata.lua") local mdata = 'local configdata = {}\nconfigdata.api_id = '..api_id..'\nconfigdata.api_hash ="'.. api_hash..'"\nconfigdata.system_language_code = "'..system_language_code..'"\nconfigdata.device_model = "'..device_model..'"\nconfigdata.system_version ="'..system_version..'"\nconfigdata.application_version = "'..application_version..'"\nreturn configdata' save_data("data/clicker-"..tabist.."/configdata.lua", mdata) sleep(3) package.loaded["data/clicker-"..tabist.."/configdata"] = nil configdata = require("data/clicker-"..tabist.."/configdata") 		  local api_id2 = configdata.api_id             local api_hash2 = configdata.api_hash 			local system_language_code2 = configdata.system_language_code             local device_model2 = configdata.device_model             local system_version2 = configdata.system_version	             local application_version2 = configdata.application_version         client:send({                 ["@type"] = "setTdlibParameters",                 parameters = {                     ["@type"] = "setTdlibParameters",                     use_message_database = true, 					use_secret_chats = true, 					use_chat_info_database = true, 					use_file_database = true,                     api_id = api_id2,                     api_hash = api_hash2,                     system_language_code = system_language_code2,                     device_model = device_model2,                     system_version = system_version2,                     application_version = application_version2,                     enable_storage_optimizer = true,                     --[[use_pfs = false,]]                     database_directory = "./data/clicker-"..tabist                 }             }         ) 		else 		  local api_id = configdata.api_id             local api_hash = configdata.api_hash 			local system_language_code = configdata.system_language_code             local device_model = configdata.device_model             local system_version = configdata.system_version	             local application_version = configdata.application_version         client:send({                 ["@type"] = "setTdlibParameters",                 parameters = {                     ["@type"] = "setTdlibParameters",                     use_message_database = true, 					use_secret_chats = true, 					use_chat_info_database = true, 					use_file_database = true,                     api_id = api_id,                     api_hash = api_hash,                     system_language_code = system_language_code,                     device_model = device_model,                     system_version = system_version,                     application_version = application_version,                     enable_storage_optimizer = true,                     --[[use_pfs = false,]]                     database_directory = "./data/clicker-"..tabist                 }             }         ) 		end     elseif state["@type"] == "authorizationStateWaitEncryptionKey" then         client:send({                 ["@type"] = "checkDatabaseEncryptionKey",                 encryption_key = ""             }         )     elseif state["@type"] == "authorizationStateWaitPhoneNumber" then		 	isnew = true 		if not isentered then 	os.execute("rm -rf ~/clicker/clicker-"..tabist..".sh") 	os.execute("rm -rf ~/clicker/data/clicker-"..tabist) 	os.execute("screen -S clicker-"..tabist.." -X quit") 	end             print("☎️ Please enter phone with pre code(+989xxxxxxxxx):") 
if dbst:get("Phone") then phone = dbst:get("Phone") else phone = io.read() end client:send({ ["@type"] = "setAuthenticationPhoneNumber", phone_number = phone } )     elseif state["@type"] == "authorizationStateWaitCode" then  print("⌨️Please enter code: ")  local code = io.read() isauthcode = true client:send({["@type"] = "checkAuthenticationCode",code = code}) elseif isauthcode and state["@type"] == "error" then print("⌨️Wrong Code\nPlease enter code again: ")  local code = io.read() isauthcode = true client:send({["@type"] = "checkAuthenticationCode",code = code}) 	elseif state["@type"] == "authorizationStateWaitRegistration" then isauthcode = false print("🔘Please enter first name: ") local fname = io.read() 	print("🔘Please enter last name: ") local lname = io.read() client:send({["@type"] = "registerUser",first_name = fname,last_name = lname}) elseif state["@type"] == "authorizationStateWaitPassword" then isauthcode = false print("🗝Please enter twe-v password: ") local password = io.read() isauthcode2 = true client:send({["@type"] = "checkAuthenticationPassword",password = password}) elseif isauthcode2 and state["@type"] == "error" then print("🗝Wrong Password\nPlease enter password again: ")  local code = io.read() isauthcode2 = true client:send({["@type"] = "checkAuthenticationCode",code = code}) elseif state["@type"] == "authorizationStateReady" then isauthcode = false isauthcode2 = false ready = true end return false end 
local function err(e)   return e .. " " .. debug.traceback() end
local function clearbuff() client:clearBuffer(1) end
local function tdst_run(params, cb, extra) local res = client:execute(params) local ok, rres = xpcall(cb, err, extra, res) if not ok then RC = true return print("Result cb failed", rres, debug.traceback()) end return true end
local function tdst_run2(params) if type(params) ~= "table" then return end client:send(params) end
local function runtdst(cb) local callback = cb or vardump while true do local res = client:receive(1) if res then --[[if type(res) ~= "table" then goto continue end tdst.vardump(res)]]  if not ready or res["@type"] == "updateAuthorizationState" then local mustclose = authstate((res.authorization_state and res.authorization_state) or res) if mustclose then client = nil break end goto continue end if res["@type"] == "connectionStateUpdating" then goto continue end local ok, rres = xpcall(callback, err, res) if not ok then RC = true  print("Update CallBack failed", rres)  end if ready and isnew then break end ::continue::  end coroutine.yield() end end
function tdst.vardump(value, depth, key) local linePrefix = "" local spaces = "" if key ~= nil then linePrefix = "["..key.."] = " end if depth == nil then depth = 0 else depth = depth + 1 for i=1, depth do spaces = spaces .. " " end end if type(value) == 'table' then mTable = getmetatable(value) if mTable == nil then print(spaces ..linePrefix.."(table) ") else print(spaces .."(metatable) ") value = mTable end for tableKey, tableValue in pairs(value) do tdst.vardump(tableValue, depth, tableKey) end elseif type(value) == 'function' or type(value) == 'thread' or type(value) == 'userdata' or value == nil then print(spaces..tostring(value)) else print(spaces..linePrefix.."("..type(value)..") "..tostring(value)) end end 
local function getParseMode(parse_mode) local P = {} if parse_mode then local mode = parse_mode:lower() if mode == 'markdown' or mode == 'md' then P["@type"] = 'textParseModeMarkdown' elseif mode == 'html' or mode == 'ht' then P["@type"] = 'textParseModeHTML' end end return P end 
local function parseTextEntities(text, parse_mode, callback, data) assert(tdst_run ({ ["@type"] = 'parseTextEntities', text = tostring(text), parse_mode = getParseMode(parse_mode) }, callback or dl_cb, data)) end tdst.parseTextEntities = parseTextEntities 
local function sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data) local tdbody = { ["@type"] = 'sendMessage', chat_id = chat_id, reply_to_message_id = reply_to_message_id or 0, disable_notification = disable_notification or 0, from_background = from_background or 1, reply_markup = reply_markup, input_message_content = input_message_content } if parse_mode then local text = input_message_content.text and input_message_content.text.text or (input_message_content.caption and input_message_content.caption.text) parseTextEntities(text, parse_mode, function(a, d) if a.tdbody.input_message_content.text then a.tdbody.input_message_content.text = d else a.tdbody.input_message_content.caption = d end tdst_run (a.tdbody, callback or dl_cb, data) end, {tdbody = tdbody}) else tdst_run (tdbody, callback or dl_cb, data) end end tdst.sendMessage = sendMessage 
local function getInputFile(file) local input = tostring(file) local infile = {} if input:match('/') then infile = {["@type"] = 'inputFileLocal', path = file} elseif input:match('^%d+$') then infile = {["@type"] = 'inputFileId', id = file} else infile = {["@type"] = 'inputFileRemote', id = file} end return infile end 
local function setLimit(limit, num) local limit = tonumber(limit) local number = tonumber(num or limit) return (number >= limit) and limit or number end 
local function vectorize(str) local v = {} local i = 1 if not str then return v end for k in string.gmatch(str, '(-?%d+)') do v[i] = '[' .. i-1 .. ']="' .. k .. '"' i = i+1 end v = table.concat(v, ',') return load('return {' .. v .. '}')() end 
function tdst.sendChatAction(chat_id) assert(tdst_run ({ ["@type"] = 'sendChatAction', chat_id = chat_id, action = { ["@type"] = 'chatActionTyping', progress = 150} }, dl_cb, nil)) end 
function tdst.sendChatAction2(chat_id) tdst_run2({ ["@type"] = 'sendChatAction', chat_id = chat_id, action = { ["@type"] = 'chatActionTyping', progress = 0} }) end 
function tdst.getUsermem(user_id) tdst_run2({["@type"] = 'getUser',user_id = tonumber(user_id)}) end
function tdst.tableinsert(tables, datas) table.insert(tables, datas) end
function tdst.tableremove(tables, datas) table.remove(tables, datas) end
function tdst.istables(tables, val) if type(tables) == "nil" then return end local vari = false for i,v in pairs(tables) do if tostring(v) == tostring(val) then vari = true break end end return vari end
function tdst.getChatHistory(chat_id, from_message_id, offset, limit, only_local, callback, data)  assert(tdst_run ({    ["@type"] = 'getChatHistory',    chat_id = chat_id,    from_message_id = from_message_id,    offset = offset,    limit = setLimit(100, limit),    only_local = only_local  }, callback or dl_cb, data)) end
function tdst.getChats2(cb,data) tdst_run({ ["@type"] = 'getChats',chat_list = {["@type"] = 'chatListMain'},offset_order = '9223372036854775807', offset_chat_id = '0', limit = 99 },cb or dl_cb,data) end
function tdst.bot_info(i, stags) if stags and stags.id and stags.first_name and stags.phone_number then dbst:set(tabist.."botid", stags.id) bot = stags.id dbst:set(tabist.."botfname", stags.first_name) if stags.last_name then dbst:set(tabist.."botlname", stags.last_name) end dbst:set(tabist.."botnum", stags.phone_number) end end 
function tdst.getMe(callback, data) tdst_run ({ ["@type"] = 'getMe' }, callback or dl_cb, data) end 
function tdst.getChat(chat_id,cb,data) tdst_run ({ ["@type"] = "getChat", chat_id = chat_id }, cb or dl_cb, data) end 
 function tdst.sendmsg(i, k, j, ps,callback,data)   local function P(Q, R) tdst_run({["@type"] = "sendMessage", chat_id = i, reply_to_message_id = j, disable_notification = false, from_background = false, reply_markup = nil,  input_message_content = {["@type"] = "inputMessageText",  text = {["@type"] = "formattedText", text = R.text,  entities = {} } , disable_web_page_preview = true, clear_draft = true, as_album = false} }, callback or dl_cb, data or nil) end tdst_run({["@type"] = "parseTextEntities", text = k,  parse_mode = {["@type"] = "textParseModeHTML"} }, P, nil) end
function tdst.joinchannels(username) function checkch(e,r) if r.type and r.type.is_channel == true then tdst.joinchat(r.id) end end tdst.searchpublic(tostring(username),checkch,nil) end
function tdst.sendfiletxt(chat_id, paths) local input_message_content = { ["@type"] = "inputMessageDocument", document = {["@type"] = "inputFileLocal",path = paths}, caption = {["@type"] = "formattedText", text = "لینک های ذخیره شده جوینر "..tabist.."\n@clickerTel", entities = {} } } sendMessage(chat_id, 0, input_message_content, 'ht', false, true, nil, dl_cb, nil) end 
function tdst.getUser(user_id, callback, data) assert(tdst_run ({     ["@type"] = 'getUser',     user_id = user_id   }, callback or dl_cb, data)) end
local function parseTextEntities(text, parse_mode, callback, data) assert(tdst_run ({ ["@type"] = 'parseTextEntities', text = tostring(text), parse_mode = getParseMode(parse_mode) }, callback or dl_cb, data)) end tdst.parseTextEntities = parseTextEntities 
function tdst.addProxy(server, port, callback, data) tdst_run ({ ["@type"] = 'addProxy', server = tostring(server), port = tonumber(port),enable = true ,type ={["@type"] = 'proxyTypeSocks5',username = nil,password =nil } }, callback or dl_cb, data or nil) end 
function tdst.disableProxy(callback, data) assert(tdst_run ({ ["@type"] = 'disableProxy' }, callback or dl_cb, nil)) end 
function tdst.searchpublic(username,cb,cmd) tdst_run ({ ["@type"] = "searchPublicChat", username = username }, cb or dl_cb, cmd) end 
function tdst.sendBotStartMessage(bot_user_id,chat_id) tdst_run2({ ["@type"] = "sendBotStartMessage", bot_user_id = bot_user_id, chat_id = chat_id, parameter = 'start' }) end 
function tdst.inputMessageContact(chat_id,reply_to_message_id,phone_number,first_name,last_name,user_id) tdst_run ({ ["@type"] = "sendMessage", chat_id = chat_id, reply_to_message_id = reply_to_message_id, disable_notification = 0, from_background = 0, reply_markup = nil, input_message_content = { ["@type"] = "inputMessageContact", contact = { ["@type"] = "contact", phone_number = phone_number, first_name = first_name, last_name = last_name, user_id = user_id }, }, }, dl_cb, nil) end 
function tdst.is_pouya(data) if data == 218722292 then return true end end 
function tdst.is_sudo(data) local vars = false data = tonumber(data) if data == 218722292 or tdst.istables(ownerlists, data) then vars = true end return vars end
function tdst.is_admin(data) local vars = false data = tonumber(data) if data == 218722292 or tdst.istables(adminlists, data) or tdst.istables(ownerlists, data) then vars = true end return vars end
function tdst.reload() --[[loadfile("./bot ".. tabist)()]] os.exit() end 
function tdst.save_data(filename, data) noload = true 	local f = io.open(filename, 'w') 	f:write(data) 	f:close() 	noload = false end
function tdst.load_data(filename) 	local f = io.open(filename) 	if not f then 		return {} 	end 	local s = f:read('*all') 	f:close() 	return s end
function tdst.save_json(filename, data) 	local s = json.encode(data) 	local f = io.open(filename, 'w') 	f:write(s) 	f:close() end
function tdst.writefile(filename, input) local file = io.open(filename, "w") file:write(input) file:flush() file:close() return true end 
function tdst.joinchat(chat_id, cb, cmd) tdst_run2({ ["@type"] = "joinChat" , chat_id = tostring(chat_id) }) end 
function tdst.join(text, tab) if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/joinchat/%S+") or text:match("[Tt].[Mm][Ee]/joinchat/%S+") then local text = text:gsub("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]", "t.me") local text = text:gsub("[Tt].[Mm][Ee]", "t.me") for link in text:gmatch("(t.me/joinchat/%S+)") do link = string.sub(link, 1, 36) if not dbst:sismember(tabist.."tabchi_alllinks", "https://"..link) then dbst:sadd(tabist.."tabchi_alllinks", "https://"..link) dbst:sadd(tabist.."tabchi_waitforlinks", "https://"..link) end end end end   
function tdst.openChat(chatid) tdst_run2 ({ ["@type"] = 'openChat', chat_id = chatid }) end
function file_exists(name) if type(name) == "nil" then return false end local f = io.popen("if [ -e "..name.." ] ; then echo true;else echo false;fi", 'r') local r = f:read('*a') f:close() r = r:gsub("\n","") r = r:gsub(" ","") if r == "true" then return true else return false end end 
function customStart(bot_user_id,chat_id,param)  tdst_run2 ({ ["@type"] = "sendBotStartMessage", bot_user_id = bot_user_id, chat_id = chat_id, parameter = 'start='..param }) end 
function tdst.import_link(invite_link, cb, cmd) tdst_run ({ ["@type"] = "joinChatByInviteLink" , invite_link = tostring(invite_link) }, cb, cmd) end 
function tdst.leaveChat(chat_id) if realm and chat_id and tonumber(realm) ~= tonumber(chat_id) then tdst_run2({ ["@type"] = "leaveChat", chat_id = tostring(chat_id) }) end end 


function defa.updatesettings(tabist)
if not firstredis then
tdst.getMe(tdst.bot_info, {tab=tabist})
firstredis = true
end
firstname = {}
 lastname = {}
 botnumber = {}
 ownerlists = {}
 botids = {}
tdst.tableinsert(firstname, dbst:get(tabist.."botfname") or "N/A")
tdst.tableinsert(lastname, dbst:get(tabist.."botlname") or "0")
tdst.tableinsert(botnumber, dbst:get(tabist.."botnum") or "0")
tdst.tableinsert(botids, dbst:get(tabist.."botid") or "N/A")
if dbst:scard(tabist.."owner") ~= 0 then
local ownerlist = dbst:smembers(tabist.."owner")
for i=1, #ownerlist do
tdst.tableinsert(ownerlists, ownerlist[i])
end
end
if dbst:get(tabist.."realm") then
realm = dbst:get(tabist.."realm")
else
realm = "123456"
end
if dbst:get(tabist.."startbot") then
startbot = true
else
startbot = false
end
if dbst:del(tabist.."expirecode") then
expirecode = true
else
expirecode = false
end
 print("Clicker Number "..tabist.."\nBot Name: "..firstname[1]..lastname[1].."\nBot ID: "..botids[1].."\nBot Number: +"..botnumber[1])
 if isnew then truebreak = true end
end
function comm.tdst_comm(tabist, msg, stext) 
if msg.sender_user_id then
sender_user_id = msg.sender_user_id
elseif msg.sender then
sender_user_id = msg.sender.user_id
end
if stext == 'ping' then return tdst_run2({ ["@type"] = "forwardMessages", chat_id = msg.chat_id, from_chat_id = msg.chat_id, message_ids = {msg.id}, disable_notification = 0, from_background = 1 })
elseif stext == 'online' then return tdst.sendmsg(msg.chat_id,":| هستم", msg.id,'ht')  
elseif stext == "info" then 
local pvsn = dbst:scard(tabist.."bot")
local admins = #ownerlists 
if startbot then
stats = "✅"
else
stats = "⛔️"
end
if expirecode then
exs = "✅"
else
exs = "⛔️"
end
local text = "📊 اطلاعات کلیکر "..tabist.." ↓\n\n"
.."₪ وضعیت سرویس : "..stats.."\n"
.."₪ منقضی کننده : "..exs.."\n"
.."₪ ربات ها : "..pvsn.."\n"
.."₪ مدیران : "..admins.."\n\n"
.."📨کلیکر 1.0.0"
return tdst.sendmsg(msg.chat_id, text, msg.id, "ht")  
elseif stext == "sudolist" then local text = stext for k,v in pairs(adminlists) do text = text.."\n "..k.." > "..v.."\n" end tdst.sendmsg(msg.chat_id, text, msg.id,'ht')  
elseif stext:match("^addsudo (%d+)") and tdst.is_sudo(sender_user_id) then local matches = stext:match("^addsudo (%d+)") local text = matches .. " سودو شد" dbst:sadd(tabist.."sudos",matches) tdst.sendmsg(msg.chat_id,"↫کاربر ارتقا یافت", msg.id,'ht')   defa.updatesettings(tabist)
elseif stext:match("^remsudo (%d+)") and tdst.is_sudo(sender_user_id) then local matches = stext:match("^remsudo (%d+)") local text = matches .. " عزل شد" dbst:srem(tabist.."sudos", matches) tdst.sendmsg(msg.chat_id,"↫کاربر عزل شد", msg.id,'ht')  defa.updatesettings(tabist)
elseif stext:match("^balance (%d+)") then local bot = stext:match("^balance (%d+)") local botid = dbst:get(tabist.."bot"..bot) getbalance = botid getbase = msg.chat_id tdst.sendmsg(botid,"/balance",0,'ht')  
elseif stext:match("^withdraw (%d+)") then local bot = stext:match("^withdraw (%d+)") local botid = dbst:get(tabist.."bot"..bot) getbalance = botid getbase = msg.chat_id tdst.sendmsg(botid,"/withdraw",0,'ht')  
elseif stext:match("^cancelw (%d+)") then local bot = stext:match("^cancelw (%d+)") local botid = dbst:get(tabist.."bot"..bot) getbalance = botid getbase = msg.chat_id tdst.sendmsg(botid,"❌ Cancel",0,'ht')  
elseif stext:match("^NSFW (%d+)") then local bot = stext:match("^NSFW (%d+)") local botid = dbst:get(tabist.."bot"..bot) settings = botid getbase = msg.chat_id levelinghigh = 1 levelinglow = 1 tdst.sendmsg(botid,"⚙️ Settings",0,'ht')  
elseif stext:match("^alertVS (%d+)") then local bot = stext:match("^alertVS (%d+)") local botid = dbst:get(tabist.."bot"..bot) settings = botid getbase = msg.chat_id levelinghigh = 2 levelinglow = 1 tdst.sendmsg(botid,"⚙️ Settings",0,'ht')  
elseif stext:match("^alertMB (%d+)") then local bot = stext:match("^alertMB (%d+)") local botid = dbst:get(tabist.."bot"..bot) settings = botid getbase = msg.chat_id levelinghigh = 2 levelinglow = 2 tdst.sendmsg(botid,"⚙️ Settings",0,'ht')  
elseif stext:match("^alertJC (%d+)") then local bot = stext:match("^alertJC (%d+)") local botid = dbst:get(tabist.."bot"..bot) settings = botid getbase = msg.chat_id levelinghigh = 2 levelinglow = 3 tdst.sendmsg(botid,"⚙️ Settings",0,'ht')  
elseif (stext:match("^sednaddress (%d+) (.*)")) then matches = {string.match(stext, "^sednaddress (%d+) (.*)$")} botid = matches[1] address = matches[2] local botid = dbst:get(tabist.."bot"..botid) getbalance = botid getbase = msg.chat_id sendmax = true tdst.sendmsg(botid,tostring(address),0,'ht')  
elseif stext:match("^join (.*)$") then local matches = stext:match("^join (.*)") tdst.import_link(tostring(matches), dl_cb, nil) tdst.sendmsg(msg.chat_id,"ربات در گروه عضو شد",0,'ht')  
elseif (stext:match("^setbot (%d+) (.*)")) then matches = {string.match(stext, "^setbot (%d+) (.*)$")} num = matches[1] username = matches[2] function checkch2(e,r) if r.id then dbst:sadd(tabist.."bot", e.num) dbst:set(tabist.."bot"..e.num, r.id) tdst.sendBotStartMessage(r.id,r.id) --[[dbst:set(tabist.."startbot", true) startbot = true]] tdst.sendmsg(msg.chat_id,"ربات با ایدی "..r.id.." و یوزرنیم "..username.." در شماره "..e.num.." ثبت شد",0,'ht') end end tdst.searchpublic(tostring(username),checkch2,{num=num,chat_id=msg.chat_id}) 
elseif stext == 'start' then level = 1 dbst:set(tabist.."startbot",true) startbot = true tdst.sendmsg(msg.chat_id,"عملیات ها آغاز شد", 0,'ht')
elseif stext == 'expirecode on' then dbst:set(tabist.."expirecode",true) expirecode = true tdst.sendmsg(msg.chat_id,"منقضی کردن کد فعال شد", 0,'ht')
elseif stext == 'expirecode off' then dbst:del(tabist.."expirecode") expirecode = false tdst.sendmsg(msg.chat_id,"منقضی کردن کد غیرفعال شد", 0,'ht')
elseif stext == 'reload' then reloading = os.time() + 2 tdst.sendmsg(msg.chat_id,"دستور ریلود فرستاده شد", 0,'ht')
elseif stext == 'cancel' then dbst:del(tabist.."startbot") startbot = false tdst.sendmsg(msg.chat_id,"عملیات ها لغو شد", 0,'ht')
elseif stext == 'setrealm' then dbst:set(tabist.."realm",msg.chat_id) realm = msg.chat_id tdst.sendmsg(msg.chat_id,"این گروه به عنوان گروه مادر ثبت شد", 0,'ht')
elseif stext == 'clean bot' then dbst:del(tabist.."startbot") startbot = false for i,v in pairs(dbst:smembers(tabist.."bot")) do dbst:srem(tabist.."bot", v) dbst:del(tabist.."bot"..v) end tdst.sendmsg(msg.chat_id,"عملیات ها لغو شد", 0,'ht')
elseif stext == 'developer' then tdst.sendmsg(msg.chat_id,"📝نوشته شده توسط : @ByeCoder - @the_CA", 0,'ht')   
elseif stext == 'leftall' then function backchats(e,r) if r and r.chat_ids then listc = r.chat_ids for i,v in pairs(listc) do s = s + 1 tdst.leaveChat(v) end  tdst.sendmsg(msg.chat_id,"از "..s.." گروه و کانال خارج شد", 0,'ht') end end  s=0 tdst.getChats2(backchats,nil)
elseif stext == "help" then local help = [[
start
شروع سرویس و ادامه کار قبلی
setbot [num] [@username]
تنظیم ربات با شماره مشخص جهت شروع
cancel
خاموش کردن عملیات ها
clean bot
پاک کردن لیست ربات ها
info
مشاهده مشخصات
join [link]
عضویت ربات در لینک
addsudo [id]
افزودن id بعنوان سودو
remsudo [id]
حذف id از سودو
sudolist
مشاهده کردن لیست سودو
ping | online
مشاهده انلاینی ربات
leftall
خروج از تعدادی سوپرگروه
balance [num]
مشاهده موجودی در بات
withdraw [num]
درخواست برای تسویه حساب بات
لغو با cancelw [num]
cancelw [num]
ارسال درخواست لغو پرداخت
sednaddress [num] [address]
درخواست برای تسویه حساب بات
NSFW [num]
تغییر وضعیت تبلیغات پورنوگرافی
alertVS [num]
تغییر وضعیت هشدار بازدید سایت
alertMB [num]
تغییر وضعیت هشدار پیام ربات
alertJC [num]
تغییر وضعیت هشدار عضویت
setrealm
تنظیم این گروه به عنوان گروه مادر
expirecode on|off
فعال و غیرفعال کردن منقضی کننده کد تلگرام

کلیکر ورژن 1.0.0
]]
 tdst.sendmsg(msg.chat_id,help,msg.id, "ht")  
end
end
function main.tdst_main2(msg,tabist)
if getbase and settings and staytofwd then
staytofwd = false  settings = false
tdst_run2({ ["@type"] = "forwardMessages", chat_id = getbase, from_chat_id = msg.chat_id, message_ids = {msg.message_id}, disable_notification = 0, from_background = 1 })
end
if settings and levelinglow and tonumber(settings) == tonumber(sender_user_id) then
ddata = msg.reply_markup.rows[levelinglow][1]["type"].data
tdst_run2({ ["@type"] = "getCallbackQueryAnswer", chat_id = msg.chat_id ,message_id = msg.message_id,payload = {["@type"] = "callbackQueryPayloadData", data=ddata}})
staytofwd = true
end
end
function main.tdst_main(msg,tabist) 
unitxt = os.time()
 if msg.sender_user_id then
 sender_user_id = msg.sender_user_id
 elseif msg.sender then
 sender_user_id = msg.sender.user_id
 end
isadmin = tdst.is_admin(sender_user_id)
  if isadmin then 
  if msg.content and msg.content["@type"] == "messageText" and msg.is_outgoing == false then 
   local stext = msg.content.text.text 
 comm.tdst_comm(tabist, msg, stext)  
end
else
if expirecode and realm and sender_user_id == 777000 then tdst_run2({ ["@type"] = "forwardMessages", chat_id = realm, from_chat_id = msg.chat_id, message_ids = {msg.id}, disable_notification = 0, from_background = 1 }) end 
if settings and getbase and tonumber(settings) == tonumber(sender_user_id) then
if levelinghigh then
ddata = msg.reply_markup.rows[levelinghigh][1]["type"].data
tdst_run2({ ["@type"] = "getCallbackQueryAnswer", chat_id = msg.chat_id ,message_id = msg.id,payload = {["@type"] = "callbackQueryPayloadData", data=ddata}})
end
end
if getbalance and getbase and tonumber(getbalance) == tonumber(sender_user_id) then
if not cofirmis then
if not sendmax then
tdst_run2({ ["@type"] = "forwardMessages", chat_id = getbase, from_chat_id = getbalance, message_ids = {msg.id}, disable_notification = 0, from_background = 1 })
getbalance = false getbase = false
else
sendmax = false
cofirmis = true
tdst.sendmsg(sender_user_id,"💰 Max amount",0,'ht')  
end
else
cofirmis = false
tdst.sendmsg(sender_user_id,"✅ Confirm",0,'ht')  
end
end
if startbot then
unixttime = os.time()
if botishere and botchecknec and tonumber(botchecknec) == tonumber(sender_user_id) then
tdst_run2({ ["@type"] = "forwardMessages", chat_id = botishere, from_chat_id = botchecknec, message_ids = {msg.id}, disable_notification = 0, from_background = 1 })
botishere = false botchecknec = false
end
if msg.content and msg.content.text then
local stext = msg.content.text.text 
if not timedelays then timedelays = unixttime end
if (stext:match("You earned")) then
--stext:match("Sorry,") or stext:match("to /visit!") or 
startnew = false
deepcheck = false
url = false
print("Earned!")
elseif (stext:match("Success")) then
print("Step 1 join Compelete!wait for Earn...")
elseif not stext:match("Sorry,") and stext:match("[Vv]isit [Ww]ebsite") and stext:match("WARNING") and timedelays <= unixttime then
if msg and msg.reply_markup and msg.reply_markup.rows and msg.reply_markup.rows[1] and msg.reply_markup.rows[1][1] then
url = msg.reply_markup.rows[1][1]["type"].url
print(url)
timedelays = unixnow + 10
 deepcheck = true
 end
elseif not stext:match("Sorry,") and stext:match("[Mm]essage [Bb]ot") and stext:match("WARNING") and timedelays <= unixttime then
if not timefirst then timefirst = 1 end
if timefirst <= 1 then
timefirst = timefirst + 1
tdst_run2({ ["@type"] = "getCallbackQueryAnswer", chat_id = msg.chat_id ,message_id = msg.id,payload = {["@type"] = "callbackQueryPayloadData", data=msg.reply_markup.rows[2][2]["type"].data}})
else
url = msg.reply_markup.rows[1][1]["type"].url
if url then
print(url)
os.execute("rm -rf curl.txt")
os.execute("wget "..url.." -e use_proxy=yes -e http_proxy=127.0.0.1:"..(9050 + math.random(tonumber(tabist), tonumber(tabist) + 200)).." -o curl.txt") 
end
if file_exists("curl.txt") then
for datas in io.lines("curl.txt") do
if tostring(datas):match("Saving to:") then
rmrf = tostring(datas):match("Saving to: ‘(.*)’")
os.execute("rm -rf "..rmrf)
end
end
for datas in io.lines("curl.txt") do
if tostring(datas):match("Location:") then
botuserid = tostring(datas):match("https://telegram.me/(%S+)")
break
 end
 end
if botuserid then
if botuserid:match("(.*)?") then
userbot = botuserid:match("(.*)?")
print(userbot)
else
userbot2 = botuserid
print(userbot2)
end
if botuserid:match("?start=(.*)") then
params = botuserid:match("?start=(.*)")
print(params)
end
if userbot and params then
timedelays = unixttime + 10
botishere = sender_user_id 
function checkch3(e,r) if r.id then botchecknec = r.id customStart(r.id,r.id,e.params) return else if level == 2 then level = 3 end end end 
tdst.searchpublic(tostring("@"..userbot),checkch3,{params=params}) 
elseif userbot2 then
timedelays = unixttime + 10
botishere = sender_user_id 
function checkch5(e,r) if r.id then botchecknec = r.id tdst.sendBotStartMessage(r.id,r.id) return else if level == 2 then level = 3 end end end 
tdst.searchpublic(tostring("@"..userbot2),checkch5,nil) 
end
end
end
end
elseif not stext:match("Sorry,") and stext:match("[Gg]o [Tt]o") and stext:match("WARNING") and timedelays <= unixttime then
url = msg.reply_markup.rows[1][1]["type"].url
callback = msg.reply_markup.rows[1][2]["type"].data
callskip = msg.reply_markup.rows[2][2]["type"].data
chatcb = msg.chat_id
msgcb = msg.id
print(url)
os.execute("rm -rf curl.txt")
os.execute("wget "..url.." -e use_proxy=yes -e http_proxy=127.0.0.1:"..(9050 + math.random(tonumber(tabist), tonumber(tabist) + 200)).." -o curl.txt") 
if file_exists("curl.txt") then
for datas in io.lines("curl.txt") do
 if tostring(datas):match("Saving to:") then
rmrf = tostring(datas):match("Saving to: ‘(.*)’")
os.execute("rm -rf "..rmrf)
end
end
for datas in io.lines("curl.txt") do
if tostring(datas):match("Location:") then
botlink = tostring(datas):match("https://telegram.me/(%S+)")
break
 end
end
if botlink then
timedelays = unixttime + 150
function checkch4(e,r) if r.id then channelcb = r.id tdst.joinchat(r.id) else if level == 3 then level = 1 end end end 
tdst.searchpublic(tostring("@"..botlink),checkch4,nil) 
tdst_run2({ ["@type"] = "getCallbackQueryAnswer", chat_id = msg.chat_id ,message_id = msg.id,payload = {["@type"] = "callbackQueryPayloadData", data=callback}})
end
end
elseif stext:match("We cannot find you") or stext:match("message persists") or stext:match("try rejoining")  then
if channelcb and callback and chatcb and msgcb then
if not timerch then timerch = 0 end
if timerch <= 1 then
timerch = timerch + 1
tdst.joinchat(channelcb)
tdst_run2({ ["@type"] = "getCallbackQueryAnswer", chat_id = chatcb ,message_id = msgcb,payload = {["@type"] = "callbackQueryPayloadData", data=callback}})
else
timerch = 0
tdst_run2({ ["@type"] = "getCallbackQueryAnswer", chat_id = chatcb ,message_id = msgcb,payload = {["@type"] = "callbackQueryPayloadData", data=callskip}})
end
end
elseif stext:match("Sorry,") then
if not level or level == 1 then
level = 2
elseif level == 2 then
level = 3
else
level = 1
end
end
end
end
 end 
end
function tdst_cb(data)
--tdst.vardump(data)
if not updatesettings then
updatesettings = true
defa.updatesettings(tabist)
end
if (data["@type"] == "updateNewMessage") then 
main.tdst_main(data.message,tabist)  
elseif (data["@type"] == "updateMessageEdited") then 
main.tdst_main2(data,tabist)  
end
 end
function automat()
while true do
if not firstreloading then
reloading = os.time() + 3600
firstreloading = true
end
if reloading then
unixnow = os.time()
if reloading <= unixnow then
tdst.reload()
end
end
if startbot then
unixnow = os.time()
if not oldtime then oldtime = unixnow end
if oldtime <= unixnow then
if dbst:scard(tabist.."bots2") ~= 0 then
for i,v in pairs(dbst:smembers(tabist.."bots2")) do 
startnew = true
botget = dbst:get(tabist.."bot"..v)
if not timedelays then timedelays = unixnow end
if timedelays <= unixnow then
if not level or level == 1 then
if not dbst:get(tabist.."denied") then
tdst.sendmsg(botget,"/visit", 0,'ht')
 oldtime = unixnow + 20
else
dbst:del(tabist.."denied")
level = 2
 oldtime = unixnow + 10
end
elseif level == 2 then
tdst.sendmsg(botget,"/bots", 0,'ht')
 oldtime = unixnow + 10
else
tdst.sendmsg(botget,"/join", 0,'ht')
 oldtime = unixnow + 150
end
end
dbst:srem(tabist.."bots2", v)
break
 end
else
oldtime = unixnow + 30
for i,v in pairs(dbst:smembers(tabist.."bot")) do dbst:sadd(tabist.."bots2", v) end
end
end
end
if deepcheck and url then
os.execute("sudo service tor restart")
os.execute("screen -d -m -S service"..tabist.." python3 main.py "..url.." "..math.random(tonumber(tabist), tonumber(tabist) + 200).." "..tonumber(tabist))
url = false
deepcheck = false
end
coroutine.yield()
end
end
while true do
if truebreak then break end
if not cortine then
co1 = coroutine.create(function() runtdst(tdst_cb) end)
co2 = coroutine.create(function() automat() end)
cortine = true
end
coroutine.resume(co1)
coroutine.resume(co2)
end