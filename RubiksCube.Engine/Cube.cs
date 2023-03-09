using RubiksCube.Engine.Contracts;

namespace RubiksCube.Engine {
    public class Cube {
        private readonly Color[,,] _cube;
        private class SideContainer {
            public readonly Side Side;

            public SideContainer? TopContainer;
            public SideContainer? RightContainer;
            public SideContainer? DownContainer;
            public SideContainer? LeftContainer;

            public Color[,] Colors = new Color[3, 3];
            public SideContainer(Side side) {
                Side = side;
            }
        }

        private readonly SideContainer FrontContainer = new (Side.Front);
        private readonly SideContainer TopContainer = new(Side.Top);
        private readonly SideContainer RightContainer = new (Side.Right);
        private readonly SideContainer DownContainer = new (Side.Down);
        private readonly SideContainer LeftContainer = new (Side.Left);
        private readonly SideContainer BackContainer = new (Side.Back);

        public Cube() {
            // ToDo: Random cube fields
            _cube = new Color[6, 3, 3];
            SetNeigbourhood();
        }

        public Cube(Color[,,] cube) {
            _cube = cube;
            // ToDo: Ensure that the cube from a parameter is a valid array
            // When_ invalid _Then throw CubeException("Invalid cube")
            throw new CubeException(CubeMessages.WrongSideNumber);
        }

        public void Move(Movement movement) {
            // ToDo: Write Unit Tests
            // Write implementation
        }

        private void SetNeigbourhood() {
            FrontContainer.TopContainer=TopContainer;
            FrontContainer.RightContainer=RightContainer;
            FrontContainer.DownContainer=DownContainer;
            FrontContainer.LeftContainer=LeftContainer;

            TopContainer.TopContainer=BackContainer;
            TopContainer.RightContainer=RightContainer;
            TopContainer.DownContainer=FrontContainer;
            TopContainer.LeftContainer=LeftContainer;

            RightContainer.TopContainer=TopContainer;
            RightContainer.RightContainer=BackContainer;
            RightContainer.DownContainer=DownContainer;
            RightContainer.LeftContainer=FrontContainer;

            DownContainer.TopContainer=FrontContainer;
            DownContainer.RightContainer=RightContainer;
            DownContainer.DownContainer=BackContainer;
            DownContainer.LeftContainer=LeftContainer;

            LeftContainer.TopContainer=TopContainer;
            LeftContainer.RightContainer=FrontContainer;
            LeftContainer.DownContainer=DownContainer;
            LeftContainer.LeftContainer=BackContainer;

            BackContainer.TopContainer=TopContainer;
            BackContainer.RightContainer=LeftContainer;
            BackContainer.DownContainer=DownContainer;
            BackContainer.LeftContainer=RightContainer;
        }
    }
}