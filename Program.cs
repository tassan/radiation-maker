using System;
using System.Text.Json;
using System.Threading;

namespace RadiationMaker
{
    class Program
    {
        static void Main(string[] args)
        {
            Thread thread = new Thread(GetRadiation);
            thread.Start();
        }

        static void GetRadiation()
        {
            while (true)
            {
                Console.WriteLine(JsonSerializer.Serialize(new Radiation()));
                Thread.Sleep(TimeSpan.FromSeconds(1));
            }
        }
    }
}