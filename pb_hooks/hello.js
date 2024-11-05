// Example hook
onRecordBeforeCreateRequest((e) => {
    console.log("Record creation requested:", e.record);
}, "daily_entries") 