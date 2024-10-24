module MyModule::StudentNotes {
    use aptos_framework::signer;
    use std::string::String;

    /// Struct to store student note information
    struct NoteRecord has store, key {
        student_id: String,
        subject: String,
        grade: u64,
        is_approved: bool,
    }

    /// Error codes
    const ERROR_NOT_AUTHORIZED: u64 = 1;
    const ERROR_RECORD_EXISTS: u64 = 2;

    /// Function for HOD to submit new student notes
    public fun submit_notes(
        hod: &signer,
        student_id: String,
        subject: String,
        grade: u64
    ) {
        // Verify that the signer is the HOD (in practice, you'd want more robust authorization)
        let hod_address = signer::address_of(hod);
        assert!(hod_address == @MyModule, ERROR_NOT_AUTHORIZED);

        // Create new note record
        let note = NoteRecord {
            student_id,
            subject,
            grade,
            is_approved: false,
        };

        // Move the record to HOD's account
        move_to(hod, note);
    }

    /// Function to approve submitted notes
    public fun approve_notes(
        department_admin: &signer,
        student_id: String
    ) acquires NoteRecord {
        // Verify department admin authority
        let admin_address = signer::address_of(department_admin);
        assert!(admin_address == @MyModule, ERROR_NOT_AUTHORIZED);

        // Get and update the note record
        let note_record = borrow_global_mut<NoteRecord>(@MyModule);
        assert!(note_record.student_id == student_id, ERROR_RECORD_EXISTS);
        note_record.is_approved = true;
    }
}
