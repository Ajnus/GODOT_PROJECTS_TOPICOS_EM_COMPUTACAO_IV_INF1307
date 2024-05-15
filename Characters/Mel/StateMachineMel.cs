using Godot;
using System;
using System.ComponentModel;

public partial class StateMachineMel : StateMachine
{
	[Export]
	public int id = 1;

	public override void _Ready()
	{
		// Adicione os estados
		AddState("STAND");
		AddState("JUMP_SQUAT");
		AddState("SHORT_HOP");
		AddState("FULL_HOP");
		AddState("DASH");
		AddState("MOONWALK");
		AddState("WALK");
		AddState("CROUCH");

		// Defina o estado inicial
		CallDeferred("SetState", "STAND");
	}

	public void StateLogic(Node parent, double delta)
	{
		parent.Call("UpdateFrames", delta);
		parent.Call("_PhysicsProcess", delta);
	}

	/*
	public object GetTransition(Node parent, double delta)
	{
		Mel the_parent = parent as Mel;

		// the_parent.Velocity * 2, Vector2.Zero, Vector2.Up
		the_parent.MoveAndSlide();
		the_parent.States = state.ToString();
		*/

	/*
	ramesLabel = GetNode<Label>("Frames");
	if (framesLabel != null)
	{
		framesLabel.Text = state.ToString();
	}*/

	/*
	// Lógica do estado atual
	switch (state)
	{
		case "STAND":
			//if (Input.GetActionStrength("right_" + id) == 1)
			if (Input.IsActionJustPressed("right_1"))
			{
				GD.Print("left_1");
				//the_parent.velocity.X = Mel.RUNSPEED;
				the_parent.ResetFrame();
				the_parent.Turn(false);
				//SetState("DASH");
				return "DASH";
			}
			//if (Input.GetActionStrength("left_" + id) == 1)
			if (Input.IsActionJustPressed("left_1"))
			{
				GD.Print("left_1");
				//the_parent.velocity.X = -Mel.RUNSPEED;
				the_parent.ResetFrame();
				the_parent.Turn(true);
				//SetState("DASH");
				return "DASH";	
			}
			if (the_parent.Velocity.X > 0 && state == "STAND")
			{
				//the_parent.velocity.X += Mel.TRACTION * 1;
				//the_parent.velocity.X = Mathf.Clamp(the_parent.Velocity.X, the_parent.Velocity.X, 0);
			}
			else if (the_parent.Velocity.X < 0 && state == "STAND")
			{
				//the_parent.velocity.X += Mel.TRACTION * 1;
				//the_parent.velocity.X = Mathf.Clamp(the_parent.Velocity.X, the_parent.Velocity.X, 0);
			}

			break;

		case "JUMP_SQUAT":
			// Lógica do estado de salto
			break;

		case "SHORT_HOP":
			// Lógica do salto curto
			break;

		case "FULL_HOP":
			// Lógica do salto alto
			break;

		case "DASH":
			if (Input.IsActionPressed("left_" + id))
			{
				if (the_parent.Velocity.X > 0)
					the_parent.ResetFrame();

				//the_parent.velocity.X = -Mel.DASHSPEED;
			}

			else if (Input.IsActionPressed("right_" + id))
			{
				if (the_parent.Velocity.X < 0)
					the_parent.ResetFrame();

				//the_parent.velocity.X = -Mel.DASHSPEED;
			}

			else
			{
				if (the_parent.frame >= the_parent.dash_duration-1)
					//SetState("STAND");
					return "STAND";
			}

			break;

		case "MOONWALK":
			// Lógica do Moonwalk
			break;

		case "WALK":
			// Lógica do walk
			break;

		case "CROUCH":
			// Lógica do crouch
			break;	

		default:
			return "NONE";
	}

	return "NONE";
}
*/

	/*
	public new void EnterState(string oldState, string newState)
	{
		// Implement behavior to execute when entering a new state
	}

	public new void ExitState(string oldState, string newState)
	{
		// Implement behavior to execute when exiting the current state
	}
	/*

	/*
	public bool StateIncludes(object[] stateArray)
	{
		foreach (var eachState in stateArray)
		{
			if (stateArray.Equals(eachState))
			{
				return true;
			}
		}
		return false;
	}
	*/
}
