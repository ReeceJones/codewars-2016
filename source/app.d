import std.stdio;
import std.string;
import std.range;
import std.conv;
import std.typecons;
import std.algorithm;


version(prob00)
{
	void invoke()
	{
		writeln("Arkansas, The Natural State!");
	}
}
version(prob01)
{
	void invoke()
	{
		writeln("Give us the points ", readln.stripRight());
	}
}
version(prob02)
{
	void invoke()
	{
		int d;
		readf!"%d\n"(d);
		while (d != 0)
		{
			writeln(d, " gallons per week will last ", 10000/d, " weeks");
			readf!"%d\n"(d);
		}
	}
}
version(prob03)
{
	bool likes(string str)
	{
		foreach(i, c; str)
		{
			if (i+1 < str.length)
			{
				auto next = str[i+1];
				if (c == next)
					return true;
			}
		}
		return false;
	}
	void invoke()
	{
		int entries;
		readf!"%d\n"(entries);
		foreach(z; entries.iota)
		{
			string s = readln.stripRight();
			writeln(s.likes ? "likes" : "hates", " ", s);
		}
	}
}
version(prob04)
{
	void invoke()
	{
		double base, power;
		readf!"%f %f\n"(base, power);
		while(base != 0.0 || power != 0.0)
		{
			//writeln(base * (10 ^^ power));
			double r = base * (10 ^^ power);
			writefln!"%0.2f"(r);
			readf!"%f %f\n"(base, power);
		}
	}
}
version(prob05)
{
	string tax(string s, int n)
	{
		string ret;
		for (int i = 0; i < s.length; ++i)
		{
			if (i % n != 0)
				ret ~= s[i];
		}
		return ret;
	}
	unittest
	{
		assert(tax("xCORxRECxT", 4) == "CORRECT");
		assert(tax("oodEbyeLDetteKrs", 5) == "goodbyeLetters");
	}
	void invoke()
	{
		int entries;
		readf!"%d\n"(entries);
		foreach(z; entries.iota)
		{
			string[] input = readln.stripRight().split(" ");
			int n = input[0].to!int;
			string s = input[1];
			string next = s.tax(n);
			writeln(next, " ", next.length);
		}
	}
}
version(prob06)
{
	double temp(double T, double T0, double T1, double C0, double C1)
	{
		double slope = (C1 - C0) / (T1 - T0);
		double start = C0 - (slope * T0);
		return (slope * T + start) / 8.0;
	}
	unittest
	{
		assert(temp(450, 350, 550, 160, 240) == 25.0);
		assert(temp(270, 300, 600, 150, 250) == 17.5);
		assert(temp(640, 280, 480, 170, 220) == 32.5);
	}
	void invoke()
	{
		int entries;
		readf!"%d\n"(entries);
		foreach(z; entries.iota)
		{
			double T, T0, T1, C0, C1;
			readf!"%f %f %f %f %f\n"(T, T0, T1, C0, C1);
			writeln(temp(T, T0, T1, C0, C1));
		}
	}
}

version(prob07)
{
	alias SharedInfo = Tuple!(char, "c", uint, "occurances");
	alias OccuranceMap = uint[char];
	string sharedChars(string[] words)
	{
		OccuranceMap[] occurances;
		foreach(word; words)
		{
			OccuranceMap map;
			foreach(c; word)
				map[c]++;
			occurances ~= map;
		}
		auto base = occurances[0];
		SharedInfo[] info;
		foreach(key; base.byKey)
		{
			uint occurancesPerWord = base[key];
			bool present = true;
			foreach(map; occurances)
			{
				auto val = key in map;
				if (val is null)
					present = false;
				else
				{
				uint count = map[key];
				if (count < occurancesPerWord)
					occurancesPerWord = count;
				}
			}
			if (present)
			{
				info ~= SharedInfo(key, occurancesPerWord);
			}
		}
		string built;
		foreach(i; info)
		{
			foreach(_; i.occurances.iota)
			{
				built ~= i.c;
			}
		}
		ubyte[] arr = cast(ubyte[])built;
		sort!"a < b"(arr);
		return cast(string)arr;
	}
	unittest
	{
		assert(sharedChars(["TEST", "MEANT", "TIME"]) == "ET");
		assert(sharedChars(["KINDERGARTEN", "CHICKENFEATHERS", "SPECIALITIES"]) == "AEEIT");
		assert(sharedChars(["ABSURD", "SUBORDINATE", "DUMBELLS3"]) == "BDSU");
	}
	void invoke()
	{
		uint n;
		readf!"%u\n"(n);
		foreach(_; n.iota)
		{
			string x, y, z;
			readf!"%s %s %s\n"(x, y, z);
			writeln(sharedChars([x, y, z]));
		}
	}
}

version(prob08)
{
	string[] generateShape(string word)
	{
		// the total length of the array should be (word * 2) - 1
		string[] lines;
		foreach(i; 0..(word.length * 2) - 1)
		{
			string ln;
			int prependAmount = cast(int)word.length - 1 - cast(int)i;
			if (prependAmount >= 0)
			{
				foreach(_; prependAmount.iota)
					ln ~= " ";
				ln ~= word[0..(word.length - prependAmount)];
			}
			else // prepend amount is negative
			{
				int appendAmount = -prependAmount;
				ln = word[appendAmount..$];
				foreach(_; appendAmount.iota)
					ln ~= " ";
			}
			lines ~= ln;
		}
		return lines;
	}
	void invoke()
	{
		uint n;
		readf!"%u\n"(n);
		foreach(_; n.iota)
		{
			auto lines = generateShape(readln.stripRight);
			foreach(ln; lines)
				ln.writeln;
		}
	}
}

private
{
    /// used for treadf
    string READPARAM(T...)()
    {
        string p = "readf!format(";
        static foreach(i; 0..T.length)
        {
            pragma(msg, "READPARAM: " ~ cast(char)(i + 48));
            if (i != 0)
                p ~= ",";
            p ~= "r[" ~ cast(char)(i+48) ~ "]";
        }
        p ~= ");";
        return p;
    }
}

/// read tuple from stdin
Tuple!(T) treadf(string format, T...)()
{
    Tuple!T r;
    mixin(READPARAM!T);
    return r;
}

version(prob09)
{
	int calculateTotalCubes(int w, int l, int h)
	{
		return w*l*h;
	}
	int calculatePaintedCubes(int w, int l, int h)
	{
		int core = (w - 2) * (l - 2);
		int xFace = (w - 2) * h * (w > 1 ? 2 : 1);
		int zFace = (l - 2) * h * (h > 1 ? 2 : 1);
		int yFace = core * 2;
		int bar = (h * ((w > 1 ? 2 : 1) * (h > 1 ? 2 : 1)));

		writeln(xFace + zFace + yFace + bar);
		return xFace + zFace + yFace + bar;
	}
	unittest
	{
		assert(calculateTotalCubes(3, 3, 3) == 27);
		assert(calculatePaintedCubes(3, 3, 3) == 26);

		assert(calculateTotalCubes(1, 1, 1) == 1);
		assert(calculatePaintedCubes(1, 1, 1) == 1);
	}
	alias Cube = Tuple!(int, int, int);
	void invoke()
	{
		Cube cube;
		while ((cube = treadf!("%d %d %d\n", int, int, int)) != tuple(0,0,0))
		{
			int total = calculateTotalCubes(cube[0], cube[1], cube[2]);
			int surface = calculatePaintedCubes(cube[0], cube[1], cube[2]);
			int unpainted = total - surface;
			total.writeln;
			surface.writeln;
			unpainted.writeln;
			write("A ", cube[0], "x", cube[1], "x", cube[2], " block is");
			if (unpainted == surface) writeln(" PERFECT.");
			else if (surface < unpainted) writeln(" LESS than Perfect.");
			else if (surface > unpainted) writeln(" MORE than Perfect.");
		}
	}
}

version(prob10)
{
	int determineWinner(int[][] board)
	{
		for (int i = 0; i < 3; i++)
		{
			// first check horizontal
			if (board[i][0] == board[i][1] && board[i][1] == board[i][2])
			{
				return board[i][0];
			}
			// vertical move
			if (board[0][i] == board[1][i] && board[1][i] == board[2][i])
			{
				return board[0][i];
			}
		}
		// check negative horizontal
		if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) return board[0][0];
		if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) return board[1][1];
		return 0;
	}
	void invoke()
	{
		int[][] board = [
			[0,0,0],
			[0,0,0],
			[0,0,0]
		];
		string ln;
		while ((ln = readln.stripRight) != "=========")
		{
			// fill in the board
			foreach(i, c; ln)
			{
				if (ln.length != 9) assert(false, "invalid input: bad board length");
				// board[i / 3][i % 3];
				switch(c)
				{
					default: break;
					case 'X': board[i / 3][i % 3] = 1; break;
					case 'O': board[i / 3][i % 3] = 2; break;
				}
			}
			board.determineWinner().writeln;
		}
	}
}

version(prob11)
{
	
}


version(unittest) {}
else
{
	void main()
	{
		invoke();
	}
}

