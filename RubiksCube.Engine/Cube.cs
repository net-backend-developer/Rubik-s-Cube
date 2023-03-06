namespace RubiksCube.Engine {
    public class Cube {
        private readonly Color[,,] _cube;

        public Cube() {
            // ToDo: Random cube fields
            _cube = new Color[6, 3, 3];
        }

        public Cube(Color[,,] cube) {
            _cube = cube;
            // ToDo: Ensure that the cube from a parameter is a valid array
            // When_ invalid _Then throw CubeException("Invalid cube")
        }

        public void Move(Movement movement) {
            // ToDo: Write Unit Tests
            // Write implementation
        }
    }
}