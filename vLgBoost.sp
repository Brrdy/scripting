#include <sdktools>
 
new Handle:g_veljump;
new Handle:g_velmove;
 
new Float:veljump;
new Float:velmove;
 
new AllowedJump[MAXPLAYERS+1] = false;
 
public OnClientPutInServer(client)
{
        AllowedJump[client] = false;
}
 
public OnPluginStart()
{
        veljump = 75.0
        velmove = 250.0
 
        g_veljump = CreateConVar("cc_jump_velocity", "75.0")
        g_velmove = CreateConVar("cc_move_velocity", "250.0")
       
        HookConVarChange(g_veljump, OnVelocityJumpChanged)
        HookConVarChange(g_velmove, OnVelocityMoveChanged)
}
 
public OnVelocityMoveChanged(Handle:cvar, const String:oldVal[], const String:newVal[])
{
        velmove = StringToFloat(newVal)
}
 
public OnVelocityJumpChanged(Handle:cvar, const String:oldVal[], const String:newVal[])
{
        veljump = StringToFloat(newVal)
}
 
public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
        if(!(GetEntityFlags(client) & FL_ONGROUND))
        {
                if(GetClientButtons(client) & IN_JUMP)
                {
                        if(AllowedJump[client])
                        {
                                AllowedJump[client] = false;
                                decl Float:clientangles[3]
                                GetEntPropVector(client, Prop_Data, "m_angRotation", clientangles);
                                GetAngleVectors(clientangles, clientangles, NULL_VECTOR, NULL_VECTOR)
                               
                                decl Float:vec[3]
                                GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
                               
                                new Float:finalvec[3];
                                finalvec[0]=vec[0]+clientangles[0]* velmove;
                                finalvec[1]=vec[1]+clientangles[1]* velmove;
                                finalvec[2]=vec[2]+veljump;
                                TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, finalvec)
                        }
                }
        }
        else
        {
                AllowedJump[client] = true;
        }
}
