using RubiksCube.Engine.Contracts;

namespace RubiksCube.Engine.Tests {
    public class Cube_Tests {

        [Test]
        public void TestCube() {
            Cube tested = new();

            tested.Move(new Movement(Side.Right));
        }
    }
}
