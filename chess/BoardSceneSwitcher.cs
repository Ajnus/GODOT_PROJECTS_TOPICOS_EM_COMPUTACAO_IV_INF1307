using Godot;

// TODO acertar modularização (?)
public partial class BoardSceneSwitcher : Node
{
	public void SwitchScene(string scenePath)	
	{
		GetTree().ChangeSceneToFile(scenePath);
	}
}
