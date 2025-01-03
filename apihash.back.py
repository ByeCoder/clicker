# Developed by @ByeCoder in @CATeam
import os,requests,re,random,redis,sys
from bs4 import BeautifulSoup
from time import sleep
db = None
while not db :
	db = redis.StrictRedis(host='localhost', port=6379, db=0)
def _redis_Connection_del(*args, **kwargs):
    return
redis.connection.Connection.__del__ = _redis_Connection_del
class Config(object):
	apptitle = "Telegram"
	appshort = "Telegram"
	appurl = ""
	appdescribe = "Telegram is a cloud-based mobile and desktop messaging app with a focus on security and speed."
	APP_TITLE = os.environ.get("APP_TITLE", apptitle)
	APP_SHORT_NAME = os.environ.get("APP_SHORT_NAME", appshort)
	APP_URL = os.environ.get("APP_URL", appurl)
	APP_DESCRIPTION = os.environ.get("APP_DESCRIPTION", appdescribe)
class Config2(object):
	appshort = "Telegram"+"".join(random.choice('1234567890') for _ in range(3))
	apptitle = "Telegram"+"".join(random.choice('1234567890') for _ in range(3))
	APP_TITLE = os.environ.get("APP_TITLE", apptitle)
	APP_SHORT_NAME = os.environ.get("APP_SHORT_NAME", appshort)
class Development(Config):
	pass
class Development(Config2):
	pass
def request_tg_code_get_random_hash(input_phone_number):
    request_url = "https://my.telegram.org/auth/send_password"
    request_data = {
        "phone": input_phone_number
    }
    response_c = requests.post(request_url, data=request_data)
    json_response = response_c.json()
    return json_response["random_hash"]
def login_step_get_stel_cookie(input_phone_number,tg_random_hash,tg_cloud_password):
    request_url = "https://my.telegram.org/auth/login"
    request_data = {
        "phone": input_phone_number,
        "random_hash": tg_random_hash,
        "password": tg_cloud_password
    }
    response_c = requests.post(request_url, data=request_data)
    re_val = None
    re_status_id = None
    if response_c.text == "true":
        re_val = response_c.headers.get("Set-Cookie")
        re_status_id = True
    else:
        re_val = response_c.text
        re_status_id = False
    return re_status_id, re_val
def scarp_tg_existing_app(stel_token):
    request_url = "https://my.telegram.org/apps"
    custom_header = {
        "Cookie": stel_token
    }
    response_c = requests.get(request_url, headers=custom_header)
    response_text = response_c.text
    soup = BeautifulSoup(response_text, features="html.parser")
    title_of_page = soup.title.string
    re_dict_vals = {}
    re_status_id = None
    if "configuration" in title_of_page:
        g_inputs = soup.find_all("span", {"class": "input-xlarge"})
        app_id = g_inputs[0].string
        api_hash = g_inputs[1].string
        re_dict_vals = {
            "App Configuration": {
                "app_id": app_id,
                "api_hash": api_hash
            },
            "Disclaimer": "It is forbidden to pass this value to third parties."
        }
        re_status_id = True
    else:
        tg_app_hash = soup.find("input", {"name": "hash"}).get("value")
        re_dict_vals = {
            "tg_app_hash": tg_app_hash
        }
        re_status_id = False
    return re_status_id, re_dict_vals
def create_new_tg_app(stel_token,tg_app_hash,app_title,app_shortname,app_url,app_platform,app_desc):
    request_url = "https://my.telegram.org/apps/create"
    custom_header = {
        "Cookie": stel_token
    }
    request_data = {
        "hash": tg_app_hash,
        "app_title": app_title,
        "app_shortname": app_shortname,
        "app_url": app_url,
        "app_platform": app_platform,
        "app_desc": app_desc
    }
    response_c = requests.post(
        request_url,
        data=request_data,
        headers=custom_header
    )
    return response_c
def parse_to_meaning_ful_text(in_dict):
	me_t = ""
	me_t += "📝Application Details:"
	me_t += "\n"
	me_t += "\n"
	me_t += "➡️APP_ID: "
	me_t += "{}".format(in_dict["App Configuration"]["app_id"])
	me_t += "\n"
	me_t += "➡️API_HASH: "
	me_t += "{}".format(in_dict["App Configuration"]["api_hash"])
	me_t += "\n"
	me_t += "\n"
	if db.get("APIHASH"):
		db.delete("APIHASH")
	if db.get("APIID"):
		db.delete("APIID")
	db.set("APIHASH",str("{}".format(in_dict["App Configuration"]["api_hash"])))
	db.set("APIID",str("{}".format(in_dict["App Configuration"]["app_id"])))
	return me_t

def extract_code_imn_ges(ptb_message):
    telegram__web_login_code = None
    incoming_message_text = ptb_message
    incoming_message_text_in_lower_case = incoming_message_text.lower()
    if "web login code" in incoming_message_text_in_lower_case:
        parted_message_pts = incoming_message_text.split("\n")
        if len(parted_message_pts) >= 2:
            telegram__web_login_code = parted_message_pts[1]
    elif "\n" in incoming_message_text_in_lower_case:
        print("did it come inside this 'elif' ?")
    else:
        telegram__web_login_code = incoming_message_text
    return telegram__web_login_code
def get_phno_imn_ges(ptb_message):
    my_telegram_ph_no = None
    if ptb_message is not None:
        if len(ptb_message) > 0:
            my_telegram_ph_no = ptb_message
        else:
            my_telegram_ph_no = ptb_message
    return my_telegram_ph_no
#INPUT_PHONE_NUMBER, INPUT_TG_CODE = range(2)
GLOBAL_USERS_DICTIONARY = {}
def input_phone_number(number):
	user = "123456"
	input_text = get_phno_imn_ges(number)
	if input_text is None:
		print("🚫Wrong phone number!")
		print('☎️Enter Phone number again:')
		input_text = input()
	random_hash = request_tg_code_get_random_hash(input_text)
	GLOBAL_USERS_DICTIONARY.update({user[0]: {"input_phone_number": input_text,"random_hash": random_hash}})
	print('🖥Enter Telegram Code sended to Account:')
	codetelegram = input()
	return input_tg_code(codetelegram)
def input_tg_code(codetelegram):
	user = "123456"
	current_user_creds = GLOBAL_USERS_DICTIONARY.get(user[0])
	if user[0] in GLOBAL_USERS_DICTIONARY:
		del GLOBAL_USERS_DICTIONARY[user[0]]
	provided_code = codetelegram
	if provided_code is None:
		print('🚫Wrong Code Login!')
		print('☎️Enter Phone number:')
		number = input()
		return input_phone_number(number)
	status_r, cookie_v = login_step_get_stel_cookie(current_user_creds.get("input_phone_number"),current_user_creds.get("random_hash"),provided_code)
	if status_r:
		status_t, response_dv = scarp_tg_existing_app(cookie_v)
		if not status_t:
			print("♻️Create new API_ID and API_HASH...")
			#movie_list = ['android']
			if db.get("platform"):
				movie_list = db.get("platform").decode('utf-8')
			else:
				movie_list = 'android'
			create_new_tg_app(cookie_v,response_dv.get("tg_app_hash"),Config.APP_TITLE,Config.APP_SHORT_NAME,Config.APP_URL,movie_list,Config.APP_DESCRIPTION)
		status_t, response_dv = scarp_tg_existing_app(cookie_v)
		if status_t:
			me_t = parse_to_meaning_ful_text(response_dv)
			print(me_t)
			sys.exit(0)
		else:
			print("⛔️Error while create API_ID,try again to create..")
			for x in range(1, 20):
				#movie_list = ['android']
				if db.get("platform"):
					movie_list = db.get("platform").decode('utf-8')
				else:
					movie_list = 'android'
				#movie_list = ['ubp']
				create_new_tg_app(cookie_v,response_dv.get("tg_app_hash"),Config2.APP_TITLE,Config2.APP_SHORT_NAME,Config.APP_URL,movie_list,Config.APP_DESCRIPTION)
				status_t, response_dv = scarp_tg_existing_app(cookie_v)
				if status_t:
					me_t = parse_to_meaning_ful_text(response_dv)
					print(me_t)
					sys.exit(0)
				if not status_t:
					print("♻️Try again to create new API_ID and API_HASH...")
	else:
		print("⛔️Error in Login")
	sys.exit(0)
def main():
	yn = input()
	if yn == "Y" or yn == "y":
		print('☎️Enter Phone number:')
		number = input()
		number = number.replace(" ", "")
		if db.get("Phone"):
			db.delete("Phone")
		db.set("Phone",number)
		return input_phone_number(number)
	else:
		if db.get("APIHASH"):
			db.delete("APIHASH")
		if db.get("APIID"):
			db.delete("APIID")
		if db.get("Phone"):
			db.delete("Phone")
		sys.exit(0)
		
if __name__ == "__main__":
    main()