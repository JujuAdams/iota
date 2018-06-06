#region Definitions

#macro IOTA_POSITION 0
#macro IOTA_VELOCITY 1
#macro IOTA_ACCELERATION 2
#macro IOTA_DAMPING 3
#macro IOTA_POS IOTA_POSITION
#macro IOTA_VEL IOTA_VELOCITY
#macro IOTA_ACL IOTA_ACCELERATION
#macro IOTA_DMP IOTA_DAMPING

enum E_IOTA_FAMILY {
    
    VELOCITY = 0,
    VELOCITY_ACCELERATION = 1,
    VELOCITY_ACCELERATION_DAMPING = 2,
    TIMER = 3,
    
    VEL = 0,
    VEL_ACL = 1,
    VEL_ACL_DMP = 2
    
}

#endregion

#region __private

enum __E_IOTA_DATA {
    
    NAME,
    MODE,
    POSITION,
    VELOCITY,
    ACCELERATION,
    DAMPING
    
}

#endregion