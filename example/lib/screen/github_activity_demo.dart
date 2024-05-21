import 'package:example/themes/github_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

class GithubActivityDemo extends StatefulWidget {
  static const routeName = "/demo/github-activity";

  @override
  State<StatefulWidget> createState() => _GithubActivityDemoState();
}

class _GithubActivityDemoState extends State<GithubActivityDemo> {
  @override
  Widget build(BuildContext context) {
    return Theme(data: makeGithubTheme(), child: buildScreen());
  }

  Widget buildScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("github"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [buildTimeline()],
      ),
    );
  }

  Widget buildTimeline() {
    return Timeline(events: [TimelineEventDisplay(child: Text("wow"))]);
  }
}

/// github's timeline card (the embedded type of card, not event itself)
///  <div class="profile-timeline-card bg-white border border-gray-dark rounded-1 p-3">
///      <svg class="octicon octicon-issue-closed closed d-inline-block mt-1 float-left" title="Closed" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M1.5 8a6.5 6.5 0 0110.65-5.003.75.75 0 00.959-1.153 8 8 0 102.592 8.33.75.75 0 10-1.444-.407A6.5 6.5 0 011.5 8zM8 12a1 1 0 100-2 1 1 0 000 2zm0-8a.75.75 0 01.75.75v3.5a.75.75 0 11-1.5 0v-3.5A.75.75 0 018 4zm4.78 4.28l3-3a.75.75 0 00-1.06-1.06l-2.47 2.47-.97-.97a.749.749 0 10-1.06 1.06l1.5 1.5a.75.75 0 001.06 0z"></path></svg>
///   <div class="ml-4">
///      <h3 class="lh-condensed my-0">
///        <a class="text-gray-dark" data-hovercard-type="issue" data-hovercard-url="/nuxt/content/issues/339/hovercard" href="/nuxt/content/issues/339">use content theme on existing nuxt project</a>
///      </h3>
///
///        <div class="text-gray mb-0 mt-2 ">
///          <p><a href="https://github.com/nuxt/content/edit/dev/docs/content/en/themes-docs.md">https://github.com/nuxt/content/edit/dev/docs/content/en/themes-docs.md</a>
///this example is outdated and wont work.
///<span class="pl-k">import</span> <span class="pl-s1">theme</span> <span class="pl-k">from</span> <span class="pl-s">'@nuxt/content-th…</span></p>
///        </div>
///
///      <div class="f6 text-gray mt-2">
///        10
///        comments
///      </div>
///    </div>
///  </div>
class TimelineCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
    );
  }
}

/// a indicator used at github activity timeline
/// <span class="discussion-item-icon">
///     <svg class="octicon octicon-eye" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M1.679 7.932c.412-.621 1.242-1.75 2.366-2.717C5.175 4.242 6.527 3.5 8 3.5c1.473 0 2.824.742 3.955 1.715 1.124.967 1.954 2.096 2.366 2.717a.119.119 0 010 .136c-.412.621-1.242 1.75-2.366 2.717C10.825 11.758 9.473 12.5 8 12.5c-1.473 0-2.824-.742-3.955-1.715C2.92 9.818 2.09 8.69 1.679 8.068a.119.119 0 010-.136zM8 2c-1.981 0-3.67.992-4.933 2.078C1.797 5.169.88 6.423.43 7.1a1.619 1.619 0 000 1.798c.45.678 1.367 1.932 2.637 3.024C4.329 13.008 6.019 14 8 14c1.981 0 3.67-.992 4.933-2.078 1.27-1.091 2.187-2.345 2.637-3.023a1.619 1.619 0 000-1.798c-.45-.678-1.367-1.932-2.637-3.023C11.671 2.992 9.981 2 8 2zm0 8a2 2 0 100-4 2 2 0 000 4z"></path></svg>
///  </span>
class DiscussionItemIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          color: Colors.grey),
      child: Icon(Icons.fiber_manual_record),
    );
  }
}

/// timeline date indicator by github
/// <h3 class="profile-timeline-month-heading bg-white d-inline-block h6 pr-2 py-1">
///     August <span class="text-gray">2020</span>
///    </h3>
class TimelineMonthHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "data",
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}
