import 'package:app_vote/api/core_api.dart';
import 'package:app_vote/models/candidate.dart';
import 'package:app_vote/models/election.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:app_vote/camera_page.dart';

class CandidatesPage extends StatelessWidget {
  final Election election;
  const CandidatesPage({Key? key, required this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Candidates')),
      body: Center(
        child: FutureBuilder<List<Candidate>>(
          future: CoreAPI.getCandidates(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || snapshot.data == null)
              return Text('Somethinfg went wrong please try again later');
            final candidates = snapshot.data!;
            return ListView.separated(
              separatorBuilder: ((context, index) => Divider()),
              itemBuilder: ((context, index) {
                final candidate = candidates[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    onTap: () async {
                      await availableCameras().then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(
                              cameras: value,
                              candidate: candidate,
                            ),
                          ),
                        ),
                      );
                    },
                    leading: Image.network(
                        'https://source.unsplash.com/random?sig=index'),
                    title: Text(candidate.name),
                    subtitle: Text(
                      'Party Name: ' + candidate.partyName,
                    ),
                    // leading: Image.network(
                    //     'https://source.unsplash.com/random?sig=index'),
                  ),
                );
              }),
              itemCount: candidates.length,
            );
          },
        ),
      ),
    );
  }
}
