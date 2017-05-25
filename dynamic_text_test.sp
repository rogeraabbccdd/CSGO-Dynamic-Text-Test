#include <sourcemod>
#include <sdktools>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Dynamic Text Test",
	author = "Kento from Akami Studio",
	description = "Test Dynamic Text",
	version = "1.0",
	url = "http://steamcommunity.com/id/kentomatoryoshika/"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_dtt", Command_Test, ADMFLAG_ROOT, "Test dynamic text");
}

// https://forums.alliedmods.net/showpost.php?p=2523113&postcount=8
stock int Point_WorldText(float fPos[3], float fAngles[3], char[] sText, char[] sSize ,  int r, int g, int b, any ...) 
{ 
    int iEntity = CreateEntityByName("point_worldtext"); 
     
    if(iEntity == -1) 
        return iEntity; 
     
    char sBuffer[512]; 
    VFormat(sBuffer, sizeof(sBuffer), sText, 8); 
    DispatchKeyValue(iEntity,     "message", sBuffer); 
     
    DispatchKeyValue(iEntity,     "textsize", sSize); 
     
    char sColor[11]; 
    Format(sColor, sizeof(sColor), "%d %d %d", r, g, b); 
    DispatchKeyValue(iEntity,     "color", sColor); 
     
    TeleportEntity(iEntity, fPos, fAngles, NULL_VECTOR); 
     
    return iEntity; 
}  

public Action Command_Test(int client,int args)
{
	if (args < 4)
	{
		PrintToChat(client, "Please use sm_dtt text size r g b.", client);
		return Plugin_Handled;
	}
	else
	{
		char text[1024], size[10], r[10], g[10], b[10];
		int ir, ig, ib;
		
		GetCmdArg(1, text, sizeof(text));
		GetCmdArg(2, size, sizeof(size));
		
		GetCmdArg(3, r, sizeof(r));
		ir = StringToInt(r);
		
		GetCmdArg(4, g, sizeof(g));
		ig = StringToInt(g);
		
		GetCmdArg(5, b, sizeof(b));
		ib = StringToInt(b);
		
		float pos[3];
		float clientEye[3], clientAngle[3];
		GetClientEyePosition(client, clientEye);
		GetClientEyeAngles(client, clientAngle);
		
		TR_TraceRayFilter(clientEye, clientAngle, MASK_SOLID, RayType_Infinite, HitSelf, client);
	
		if (TR_DidHit(INVALID_HANDLE))
			TR_GetEndPosition(pos);
	
		Point_WorldText(pos, clientAngle, text, size, ir, ig, ib);
		
		return Plugin_Handled;
	}
}

public bool HitSelf(int entity, int contentsMask, any data)
{
	if (entity == data)
	{
		return false;
	}
	return true;
}