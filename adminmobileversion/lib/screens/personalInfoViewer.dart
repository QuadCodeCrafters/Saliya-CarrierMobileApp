import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeProfilePage extends StatefulWidget {
  final Map<String, dynamic> passValue;
  EmployeeProfilePage(this.passValue);

  @override
  _EmployeeProfilePageState createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final Color _primaryColor = Color(0xFF1E88E5);
  final Color _accentColor = Color(0xFF64B5F6);
  final Color _backgroundColor = Color(0xFFF5F5F5);


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 24),
                  _buildPersonalInfo(),
                  SizedBox(height: 24),
                  _buildWorkInfo(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return  SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade900, Colors.blue.shade700],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><defs><style>.cls-1{fill:#201602}</style></defs><g id="Layer_2" data-name="Layer 2"><g id="layer_1-2" data-name="layer 1"><path class="cls-1" d="M37 48H7a1 1 0 0 1-1-1V29h2v17h28.59L46 36.59V2H8v5H6V1a1 1 0 0 1 1-1h40a1 1 0 0 1 1 1v36a1 1 0 0 1-.29.71l-10 10A1 1 0 0 1 37 48z"/><path class="cls-1" d="M23 30H1a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h22a1 1 0 0 1 1 1v22a1 1 0 0 1-1 1zM2 28h20V8H2z"/><path class="cls-1" d="M12 20c-2.21 0-4-2.24-4-5a3.71 3.71 0 0 1 4-4 3.71 3.71 0 0 1 4 4c0 2.76-1.79 5-4 5zm0-7c-1.79 0-2 1.14-2 2 0 1.6.93 3 2 3s2-1.4 2-3c0-.86-.21-2-2-2z"/><path class="cls-1" d="M19 25h-2v-3.31a1 1 0 0 0-.84-1L12 20l-4.16.7a1 1 0 0 0-.84 1V25H5v-3.31a3 3 0 0 1 2.51-3l4.33-.69a1.71 1.71 0 0 1 .32 0l4.33.73a3 3 0 0 1 2.51 3zM37 48a.84.84 0 0 1-.38-.08A1 1 0 0 1 36 47V37a1 1 0 0 1 1-1h10a1 1 0 0 1 .92.62 1 1 0 0 1-.21 1.09l-10 10A1 1 0 0 1 37 48zm1-10v6.59L44.59 38zM34 8h8v2h-8zM28 8h4v2h-4zM28 13h11v2H28zM36 18h6v2h-6zM28 18h6v2h-6zM28 23h14v2H28zM28 28h9v2h-9zM25 33h8v2h-8zM12 33h11v2H12zM21 38h8v2h-8zM12 38h7v2h-7z"/></g></g></svg>''',
                      height: 120,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Employee profile',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildProfileHeader() {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.passValue['Name']}',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          Text(
            'Position - ${widget.passValue['Position']}',
            style: GoogleFonts.roboto(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _buildInfoCard(
      title: 'Personal Information',
      items: [
        _buildInfoItem(Icons.email, 'Email', '${widget.passValue['Mail']}'),
        _buildInfoItem(Icons.phone, 'Phone', '${widget.passValue['Phone']}'),
        _buildInfoItem(Icons.cake, 'Birthday', '${widget.passValue['DOB']}'),
        _buildInfoItem(Icons.location_on, 'Address', '${widget.passValue['Address']}'),
        _buildInfoItem(Icons.perm_identity_outlined, 'NIC', '${widget.passValue['NationalIdentificationNumber']}'),
      ],
    );
  }

  Widget _buildWorkInfo() {
    return _buildInfoCard(
      title: 'Work Information',
      items: [
        _buildInfoItem(Icons.badge, 'Employee ID', '${widget.passValue['EmployeeID']}'),
        _buildInfoItem(Icons.monetization_on, 'Salary', '${widget.passValue['Salary']}'),
        _buildInfoItem(Icons.calendar_today, 'Join Date', '${widget.passValue['HireDate']}'),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: _accentColor, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(
        skill,
        style: GoogleFonts.roboto(color: Colors.white),
      ),
      backgroundColor: _accentColor,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

