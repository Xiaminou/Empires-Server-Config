#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = {
	name = "RG UnGrief",
	author = "Theowningone",
	description = "RG UnGrief +Neoony added colors and names.",
	version = "1.0",
	url = "http://www.theowningone.info/"
}

public OnPluginStart(){
	RegAdminCmd("sm_ungrief",UnGrief,ADMFLAG_RCON,"Ungrief a command vehicle");
}

public bool:TraceEntityFilterPlayer(entity, contentsMask){
	return entity>GetMaxClients()||!entity;
}

public Action:UnGrief(client,args){
	if(args!=1){
		PrintToChat(client,"\x04[UG]\x01 Proper Usage: !ungrief <team>");
		PrintToConsole(client,"\x04[UG]\x01 Proper Usage: sm_ungrief <team>");
		return Plugin_Handled;
	}
	decl String:arg[128];
	GetCmdArg(1,arg,128);
	new Float:vAngles[3],Float:vOrigin[3],Float:pos[3],Float:Angles[3]; 
	GetClientEyePosition(client,vOrigin);
	GetClientEyeAngles(client,vAngles);
   	new Handle:trace=TR_TraceRayFilterEx(vOrigin,vAngles,MASK_SHOT,RayType_Infinite,TraceEntityFilterPlayer);
	if(TR_DidHit(trace)){
   	 	TR_GetEndPosition(pos,trace);
   	 	pos[2]+=30.0;	
	}
	StripQuotes(arg);
	TrimString(arg);
	new String:comm[256];
	if(StrEqual(arg,"nf",false)){
		Format(comm,256,"emp_nf_commander");
		pos[2]+=50.0;	
		PrintToChatAll("\x04[UG]\x01\x07ff6600 %N\x01 teleported the\x07FF2323 Northern Faction\x01 Command Vehicle.", client);
	}else if(StrEqual(arg,"be",false)||StrEqual(arg,"imp",false)){
		Format(comm,256,"emp_imp_commander");
		PrintToChatAll("\x04[UG]\x01\x07ff6600 %N\x01 teleported the\x079764FF Brenodi Empire\x01 Command Vehicle.", client);
	}else{
		PrintToChat(client,"\x04[UG]\x01 Invalid Team");
		PrintToConsole(client,"\x04[UG]\x01 Invalid Team");
		return Plugin_Handled;
	}
	CloseHandle(trace);
	new ents=GetMaxEntities();
	new ent;
	for(new i=1;i<=ents;i++){
		if(IsValidEntity(i)){
			new String:class[256];
			GetEdictClassname(i,class,256);
			if(StrEqual(class,comm,false)){
				ent=i;
				break;
			}
		}
	}
	Angles[2]=vAngles[2];
	TeleportEntity(ent,pos,Angles,NULL_VECTOR);
	return Plugin_Handled;
}