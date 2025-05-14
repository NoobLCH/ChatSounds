namespace Functions {
    array<CScheduledFunction@> aryScheduledFunctions = {};
    bool bIsMapChanging = false;

    void ScheduleManagerInit() {
        aryScheduledFunctions = {};
        bIsMapChanging = false;
    }

    void AddSchedule(CScheduledFunction@ pFunction) {
        if (pFunction is null || pFunction.HasBeenRemoved())
            return;
        if (bIsMapChanging) {
            g_Scheduler.RemoveTimer(pFunction);
            return;
        }
        aryScheduledFunctions.insertLast(pFunction);
        UpdateArrayAvailable();
    }

    void UpdateArrayAvailable() {
        array<uint> aryRemoveIndex = {};
        for (uint i = 0; i < aryScheduledFunctions.length(); i++) {
            if (aryScheduledFunctions[i] is null) {
                aryRemoveIndex.insertLast(i);
            }
            else if (aryScheduledFunctions[i].HasBeenRemoved()) {
                @aryScheduledFunctions[i] = null;
                aryRemoveIndex.insertLast(i);
            }
        }
        if (aryRemoveIndex.length() > 0) {
            for (uint j = 0; j < aryRemoveIndex.length(); j++) {
                if (aryRemoveIndex[j] < aryScheduledFunctions.length())
                    aryScheduledFunctions.removeAt(aryRemoveIndex[j]);
            }
        }
    }

    void RemoveAllSchedule() {
        bIsMapChanging = true;
        for (uint i = 0; i < aryScheduledFunctions.length(); i++) {
            if (aryScheduledFunctions[i] !is null) {
                g_Scheduler.RemoveTimer(aryScheduledFunctions[i]);
                @aryScheduledFunctions[i] = null;
            }
        }

        aryScheduledFunctions = {};
    }
}
