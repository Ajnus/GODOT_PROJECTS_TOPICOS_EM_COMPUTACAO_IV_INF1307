using Godot;
using Godot.Collections;
using System;

public partial class Hideo : CharacterBody2D
{

	[Export]
	// How fast the player will move (pixels/sec).
	public int Speed { get; set; } = 400;
	//public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;

	// Constants
	//public Vector2 velocity = new Vector2(0, 0);

	public int dash_duration = 10;
	public const int RUNSPEED = 340;
	public const int DASHSPEED = 390;
	public const int WALKSPEED = 200;
	public const int GRAVITY = 1800;
	public const int JUMPFORCE = 500;
	public const int MAX_JUMPFORCE = 800;
	public const int DOUBLEJUMPFORCE = 1000;
	public const int MAXAIRSPEED = 300;
	public const int AIR_ACCEL = 25;
	public const int FALLSPEED = 60;
	public const int FALLINGSPEED = 900;
	public const int MAXFALLSPEED = 900;
	public const int TRACTION = 40;
	public const int ROLL_DISTANCE = 350;
	public int air_dodge_speed = 500;
	public const int UP_B_LAUNCHSPEED = 700;

	public object States;

	public Label framesLabel;
	public int frame = 0;

	public Vector2 ScreenSize;

	public FightSceneSwitcher sceneSwitcher;

	public Dictionary player_data = new Dictionary();

	public string save_path = "res://HideoStats.sav";

	public bool isFlippedH;

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

	public override void _Ready()
	{
		States = GetNode<Node>("State");
		ScreenSize = GetViewportRect().Size;
		GetNode<AnimatedSprite2D>("Sprite").Play("idle");
		//sceneSwitcher = GetNode<FightSceneSwitcher>("FightSceneSwitcher");
		//GetNode<AnimatedSprite2D>("Sprite").Connect("animation_finished", OnAnimationFinished());

		//Global GlobalScene = GetTree().Root.GetChild(0);
		//GD.Print("Nome da cena: " + GlobalScene.Name);
		//var targetNode = testStageScene.GetNode<Node2D>("MEL");	
		Global global = (Global)GetNode("/root/Global");

		//isInitialized = GlobalScene.isInitialized;
		
		//GD.Print("global.isInitializedHideo: ", global.isInitializedHideo);
		if (global.isInitializedHideo)
		{
			Load();
		}
		else
		{
			global.ExecuteOnceHideo();
		}
		//isBoot = false;
	}

	public void Save()
	{
		//GD.Print("global_position: ", GlobalPosition);
		player_data["global_position"] = GlobalPosition;

		// Acessar o AnimatedSprite2D para obter a direção
		AnimatedSprite2D sprite = GetNode<AnimatedSprite2D>("Sprite");
		bool isFlippedH = sprite.FlipH;

		// Armazenar a direção no dicionário de dados do jogador
		player_data["direction"] = isFlippedH ? "left" : "right";

		FileAccess file = FileAccess.Open(save_path, FileAccess.ModeFlags.Write);
		file.StoreVar(player_data);
		//GD.Print("global_position salva!");
		file.Close();
	}

	public void Load()
	{
		if (FileAccess.FileExists(save_path))
		{
			using var file = FileAccess.Open(save_path, FileAccess.ModeFlags.Read);
			player_data = (Dictionary)file.GetVar();
			file.Close();

			if (player_data.ContainsKey("global_position"))
			{
				//GD.Print("global_position: ", GlobalPosition);
				GlobalPosition = (Vector2)player_data["global_position"];
				//GD.Print("global_position loaded!");
			}

			if (player_data.ContainsKey("direction"))
			{
				string direction = (string)player_data["direction"];
				AnimatedSprite2D sprite = GetNode<AnimatedSprite2D>("Sprite");

				// Aplicar a direção ao AnimatedSprite2D
				sprite.FlipH = direction == "left";
			}

		}
		else
		{
			player_data = new Dictionary();
		}
		//GD.Print("Hideo:", player_data);
	}

	public void OnAnimationFinished()
	{
		var animatedSprite2D = GetNode<AnimatedSprite2D>("Sprite");
		string anim_name = animatedSprite2D.Animation;

		if (anim_name == "kick" || anim_name == "uppercut")
		{
			if (!animatedSprite2D.Animation.Equals("walk"))
			{
				animatedSprite2D.Play("idle");
			}
		}
	}

	public void SwitchToNextScene()
	{
		Save();

		if (GetParent() is TestStage parent)
		{

			//GD.Print("HIDEO: Parent node: ", parent.Name);

			sceneSwitcher = parent.sceneSwitcher;
			//GD.Print("HIDEO: parent.sceneSwitcher: ", parent.sceneSwitcher);
			if (sceneSwitcher == null)
			{
				//GD.Print("HIDEO: sceneSwitcher is null. Please check if it is properly initialized in the parent node.");
			}
			else
			{
				//GD.Print("HIDEO: sceneSwitcher accessed successfully");
			}
		}
		else
		{
			//GD.Print("HIDEO: Parent node is not of type TestStage or parent node not found.");

			//GD.Print("HIDEO: Parent node not found");
		}

		if (sceneSwitcher != null)
		{
			sceneSwitcher.SwitchScene("res://Chess/Board.tscn");
		}
		else
		{
			//GD.Print("HIDEO: sceneSwitcher is null, cannot switch scene");
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		// Speed * delta;
		// The player's movement vector.
		/*
		var velocity = Vector2.Zero; // OLD Vector2 velocity = Velocity;
		var animatedSprite2D = GetNode<AnimatedSprite2D>("Sprite");

		// Add the gravity.
		if (!IsOnFloor())
			velocity.Y += 0 * (float)delta;

		// Handle Jump.
		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JumpVelocity;

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		
		
		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * Speed;
			//animatedSprite2D.Play();
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			//animatedSprite2D.Stop();
		}
		

		Velocity = velocity;
		*/

		//MoveAndSlide();
		/*

		framesLabel = GetNode<Label>("Frames");
		if (framesLabel != null)
		{
			framesLabel.Text = frame.ToString();
		}

		//EndOfBow = GetNode<Node2D>("EndOfBow");
		//creenSize = GetViewportRect().Size;

		if (velocity.Length() > 0)
		{
			velocity = velocity.Normalized() * Speed;
			//animatedSprite2D.Play();
		}

		else
		{
			//animatedSprite2D.Stop();
		}
		
		if (velocity.X != 0)
		{
			animatedSprite2D.Animation = "walk";
			animatedSprite2D.FlipV = false;

			// See the note below about boolean assignment.
			animatedSprite2D.FlipH = velocity.X < 0;
		}
		*/

		// Speed * delta;
		// The player's movement vector.
		var velocity = Vector2.Zero;

		var animatedSprite2D = GetNode<AnimatedSprite2D>("Sprite");

		if (Input.IsActionPressed("right_2"))
			velocity.X += 1;

		if (Input.IsActionPressed("left_2"))
			velocity.X -= 1;

		//if (Input.IsActionPressed("move_down"))
		//	velocity.Y += 1;

		//if (Input.IsActionPressed("move_up"))
		//	velocity.Y -= 1;


		if (Input.IsActionPressed("up_2") && !animatedSprite2D.Animation.Equals("uppercut"))
			animatedSprite2D.Play("uppercut");

		if (Input.IsActionPressed("down_2") && !animatedSprite2D.Animation.Equals("kick"))
			animatedSprite2D.Play("kick");

		//if (Input.IsActionPressed("change_scene"))
		//SwitchToNextScene();

		/*	var sprite_frames = $AnimatedSprite2D.sprite_frames
				Get the first texture of the wanted animation (in this case, walk, you can also get the size
				in differents cases)
				If your animation frames has different sizes, use $AnimatedSprite2D.frame instead of 0
			var texture       = sprite_frames.get_frame_texture("walk", 0)
				Get frame size:
			var texture_size  = texture.get_size()
				This is not the end, you will get the texture size, not the node real size, then you need to
				multiply the texture size with the node scale
			var as2d_size     = texture_size * $AnimatedSprite2D.get_scale()
		*/

		/*
			if (velocity.Length() > 0)
			{
				velocity = velocity.Normalized() * Speed;
				animatedSprite2D.Play();
			}

			else
			{
				animatedSprite2D.Stop();
			}
			/*


			//Position += velocity * (float)delta;

			/*
			Position = new Vector2(
				x: Mathf.Clamp(Position.X, 27, ScreenSize.Y-27),
				y: Mathf.Clamp(Position.Y, 33.75f, ScreenSize.Y-33.75f) 
			);
			*/

		/*
		if (velocity.X != 0)
		{
			velocity = velocity.Normalized() * Speed;
			animatedSprite2D.Animation = "walk";
			animatedSprite2D.FlipV = false;

			// See the note below about boolean assignment.
			animatedSprite2D.FlipH = velocity.X < 0;
		}
		else if (animatedSprite2D.Animation != "uppercut" && animatedSprite2D.Animation != "kick")
		{
			animatedSprite2D.Animation = "idle";
		}
		/*

		/*
		if (velocity.Y != 0)
		{
			animatedSprite2D.Animation = "up";
			animatedSprite2D.FlipV = velocity.Y > 0;
		}
		*/


		if (Mathf.Abs(velocity.X) > 0)
		{
			velocity = velocity.Normalized() * Speed;
			animatedSprite2D.Play("walk");
			animatedSprite2D.FlipH = velocity.X > 0;
		}
		else if (!animatedSprite2D.Animation.Equals("uppercut") && !animatedSprite2D.Animation.Equals("kick"))
		{
			animatedSprite2D.Play("idle");
		}

		Position += velocity * (float)delta;


	}


	/*
	public override void _Process(float delta)
	{
		// Implement _Process logic here
	}
	*/

	public void UpdateFrames(float delta)
	{
		frame += 1;
	}

	public void Turn(bool direction)
	{
		int dir = direction ? -1 : 1;
		GetNode<AnimatedSprite2D>("Sprite").FlipH = direction;
	}

	public void ResetFrame()
	{
		frame = 0;
	}

}
