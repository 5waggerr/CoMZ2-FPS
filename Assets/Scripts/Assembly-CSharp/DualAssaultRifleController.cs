using CoMZ2;
using UnityEngine;

public class DualAssaultRifleController : AssaultRifleController
{
	private DualAssaultRifleController slave;
	private bool shootBool;
	private bool isSlave;
	private bool allowStart;

	protected override void Awake()
	{
		weapon_type = WeaponType.DualRifle;
		render_obj = base.gameObject;

		isSlave = name.EndsWith("(Clone)(Clone)");

		if (!isSlave)
		{
			slave = Instantiate(this, Vector3.down * 100f, Quaternion.identity);
			slave.name = this.name;
		}
	}

	protected override void Start()
	{
		if (isSlave && !allowStart) return;

		base.Start();
		if (slave)
		{
			slave.Reset(GetComponentInParent<PlayerController>().transform.Find("Bip01/Spine_00/Bip01 Spine/Spine_0/Bip01 Spine1/Bip01 Neck/Bip01 L Clavicle/Bip01 L UpperArm/Bip01 L Forearm/Bip01 Prop2"));
			slave.GunOn();
			slave.Accessory = Accessory;
			slave.allowStart = true;
			slave.Start();
			slave.allowStart = false;
		}
	}

	public override void SetWeaponData(WeaponData data)
	{
		base.SetWeaponData(data);
		if (slave) slave.SetWeaponData(data);
	}

	public override void GunOff()
	{
		base.GunOff();
		if (slave) slave.GunOff();
	}

	public override void GunOn()
	{
		base.GunOn();
		if (slave) slave.GunOn();
	}

	public override void Fire(PlayerController player, float deltaTime)
	{
		if (!OnReadyFire(player, deltaTime) || !weapon_data.OnFire()) return;

		if (slave)
		{
			if (!weapon_data.config.shoot_sequential)
			{
				base.Fire(player, deltaTime);
				slave.Fire(player, deltaTime);
			}
			else
			{
				shootBool = !shootBool;
				if (shootBool) base.Fire(player, deltaTime);
				else slave.Fire(player, deltaTime);
			}
		}
		else base.Fire(player, deltaTime);
	}
}
