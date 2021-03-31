from PIL import Image

teams_list_espn = ['ari','atl','bal','buf','car','chi','cin','cle','dal','den','det','gb','hou','ind','jax','kc','lac',
            'lar','mia','min','ne','no','nyg','nyj','lv','phi','pit','sf','sea','tb','ten','wsh']

basewidth = 100

for team in teams_list_espn:
    img_path = team + '.png'
    img = Image.open(img_path)
    wpercent = (basewidth/float(img.size[0]))
    hsize = int((float(img.size[1])*float(wpercent)))
    img = img.resize((basewidth,hsize), Image.ANTIALIAS)
    img.save(img_path) 