part of 'movie_screen.dart';

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  final bool isFavorite = false;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {},
          icon: isFavorite
              ? Icon(Icons.favorite, color: Colors.red)
              : Icon(Icons.favorite_border_outlined),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: SizedBox(
        //   width: double.infinity,
        //   child: Text(
        //     movie.title,
        //     style: TextStyle(fontSize: 20, color: Colors.white70),
        //     textAlign: TextAlign.start,
        //   ),
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: FadeIn(
                child: Image.network(movie.posterPath, fit: BoxFit.cover),
              ),
            ),

            const _CustomGradient(stops: [0.0, 0.3]),

            const _CustomGradient(
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
              stops: [0.0, 0.15],
              colors: [Colors.black12, Colors.transparent],
            ),
            const _CustomGradient(
              begin: AlignmentGeometry.topRight,
              end: AlignmentGeometry.bottomLeft,
              stops: [0.0, 0.15],
              colors: [Colors.black12, Colors.transparent],
            ),

            const _CustomGradient(
              begin: AlignmentGeometry.bottomCenter,
              end: AlignmentGeometry.topCenter,
              stops: [0.0, 0.3],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.topCenter,
    this.end = AlignmentGeometry.bottomCenter,
    required this.stops,
    this.colors = const [Colors.black87, Colors.transparent],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
