// Enhanced MDT System - Main JavaScript
// Handles all UI interactions and server communication

let currentTab = 'dashboard';
let currentProfile = null;
let searchResults = [];
let allReports = [];
let allWarrants = [];
let allPosters = [];

// ============================================================================
// INITIALIZATION
// ============================================================================

window.addEventListener('message', function(event) {
    const action = event.data.action;
    
    switch(action) {
        case 'open':
            openMDT();
            break;
        case 'close':
            closeMDT();
            break;
        case 'updateStats':
            updateDashboardStats(event.data.stats);
            break;
        case 'searchResults':
            displaySearchResults(event.data.results);
            break;
        case 'citizenProfile':
            displayCitizenProfile(event.data.profile);
            break;
        case 'reportList':
            displayReportList(event.data.reports);
            break;
        case 'wantedPosterList':
            displayWantedPosters(event.data.posters);
            break;
        case 'boloList':
            displayBOLOList(event.data.bolos);
            break;
        case 'vehicleInfo':
            displayVehicleInfo(event.data.vehicle);
            break;
    }
});

// Close UI on ESC key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeMDT();
    }
});

function openMDT() {
    document.getElementById('law-system').classList.remove('hidden');
    loadDashboard();
}

function closeMDT() {
    document.getElementById('law-system').classList.add('hidden');
    const resourceName = getResourceName();
    fetch(`https://${resourceName}/close`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({})
    });
}

// ============================================================================
// TAB NAVIGATION
// ============================================================================

// Setup tab navigation
document.querySelectorAll('.nav-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        const tabName = this.getAttribute('data-tab');
        switchTab(tabName);
    });
});

function switchTab(tabName) {
    // Update active tab button
    document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
    document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
    
    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(tc => tc.classList.remove('active'));
    
    // Show selected tab
    const tabContent = document.getElementById(`${tabName}-tab`);
    if (tabContent) {
        tabContent.classList.add('active');
    }
    
    currentTab = tabName;
    
    // Load tab-specific data
    switch(tabName) {
        case 'dashboard':
            loadDashboard();
            break;
        case 'records':
            loadRecordsTab();
            break;
        case 'wanted':
            loadWantedTab();
            break;
        case 'reports':
            loadReportsTab();
            break;
        case 'evidence':
            loadEvidenceTab();
            break;
        case 'dispatch':
            loadDispatchTab();
            break;
        case 'roster':
            loadRosterTab();
            break;
    }
}

// ============================================================================
// DASHBOARD
// ============================================================================

function loadDashboard() {
    fetch(`https://${getResourceName()}/getDashboardStats`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({})
    });
}

function updateDashboardStats(stats) {
    document.getElementById('active-officers').textContent = stats.activeOfficers || 0;
    document.getElementById('active-prisoners').textContent = stats.activePrisoners || 0;
    document.getElementById('active-warrants').textContent = stats.activeWarrants || 0;
    document.getElementById('total-bounties').textContent = '$' + (stats.totalBounties || 0);
}

// ============================================================================
// RECORDS TAB
// ============================================================================

function loadRecordsTab() {
    const content = document.getElementById('records-tab');
    if (!content) return;
    
    content.innerHTML = `
        <div class="parchment-panel">
            <h3 class="panel-title">Citizen Records</h3>
            
            <div class="search-section">
                <div class="search-bar">
                    <input type="text" id="citizen-search" placeholder="Search by name or ID..." class="western-input">
                    <button onclick="searchCitizens()" class="western-button">Search</button>
                    <button onclick="createNewCitizen()" class="western-button primary">New Citizen</button>
                </div>
            </div>
            
            <div id="search-results" class="results-container">
                <p class="placeholder-text">Enter a name or ID to search citizen records</p>
            </div>
        </div>
    `;
    
    // Add enter key listener to search
    document.getElementById('citizen-search').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchCitizens();
        }
    });
}

function searchCitizens() {
    const query = document.getElementById('citizen-search').value.trim();
    if (query.length < 2) {
        showNotification('Please enter at least 2 characters', 'error');
        return;
    }
    
    fetch(`https://${getResourceName()}/searchCitizens`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({query: query})
    });
}

function displaySearchResults(results) {
    const container = document.getElementById('search-results');
    if (!container) return;
    
    if (results.length === 0) {
        container.innerHTML = '<p class="placeholder-text">No citizens found</p>';
        return;
    }
    
    let html = '<div class="citizen-list">';
    results.forEach(citizen => {
        html += `
            <div class="citizen-card" onclick="viewCitizenProfile(${citizen.id})">
                <div class="citizen-mugshot">
                    ${citizen.mugshot ? `<img src="${citizen.mugshot}" alt="Mugshot">` : '<div class="no-photo">No Photo</div>'}
                </div>
                <div class="citizen-info">
                    <h4>${citizen.name}</h4>
                    <p>ID: ${citizen.identifier}</p>
                    <div class="citizen-stats">
                        <span class="stat-badge">📝 ${citizen.report_count || 0} Reports</span>
                        <span class="stat-badge">⚖️ ${citizen.arrest_count || 0} Arrests</span>
                        <span class="stat-badge">⚠️ ${citizen.warrant_count || 0} Warrants</span>
                    </div>
                </div>
                <div class="citizen-actions">
                    <button class="icon-button" title="View Profile">👁️</button>
                </div>
            </div>
        `;
    });
    html += '</div>';
    
    container.innerHTML = html;
}

function viewCitizenProfile(citizenId) {
    fetch(`https://${getResourceName()}/getCitizenProfile`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({citizenId: citizenId})
    });
}

function displayCitizenProfile(profile) {
    const citizen = profile.citizen;
    const modal = createModal('Citizen Profile: ' + citizen.name, `
        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-mugshot">
                    ${citizen.mugshot ? `<img src="${citizen.mugshot}" alt="Mugshot">` : '<div class="no-photo-large">No Photo</div>'}
                </div>
                <div class="profile-basic-info">
                    <h2>${citizen.name}</h2>
                    <p><strong>ID:</strong> ${citizen.identifier}</p>
                    <p><strong>DOB:</strong> ${citizen.date_of_birth || 'Unknown'}</p>
                    <p><strong>Gender:</strong> ${citizen.gender || 'Unknown'}</p>
                    <p><strong>Address:</strong> ${citizen.address || 'Unknown'}</p>
                    <p><strong>Phone:</strong> ${citizen.phone || 'Unknown'}</p>
                </div>
                <div class="profile-actions">
                    <button class="western-button" onclick="editCitizen(${citizen.id})">Edit</button>
                    <button class="western-button" onclick="createReportFor(${citizen.id})">New Report</button>
                    <button class="western-button" onclick="createWarrantFor(${citizen.id})">Issue Warrant</button>
                    <button class="western-button" onclick="createArrestFor(${citizen.id})">Record Arrest</button>
                    <button class="western-button danger" onclick="createWantedPosterFor(${citizen.id})">Wanted Poster</button>
                </div>
            </div>
            
            <div class="profile-tabs">
                <button class="profile-tab active" onclick="showProfileSection('reports')">Reports (${profile.reports.length})</button>
                <button class="profile-tab" onclick="showProfileSection('arrests')">Arrests (${profile.arrests.length})</button>
                <button class="profile-tab" onclick="showProfileSection('warrants')">Warrants (${profile.warrants.length})</button>
                <button class="profile-tab" onclick="showProfileSection('convictions')">Convictions (${profile.convictions.length})</button>
                <button class="profile-tab" onclick="showProfileSection('files')">Files (${profile.files.length})</button>
                <button class="profile-tab" onclick="showProfileSection('notes')">Notes</button>
            </div>
            
            <div id="profile-section-reports" class="profile-section active">
                ${renderReportsList(profile.reports)}
            </div>
            <div id="profile-section-arrests" class="profile-section">
                ${renderArrestsList(profile.arrests)}
            </div>
            <div id="profile-section-warrants" class="profile-section">
                ${renderWarrantsList(profile.warrants)}
            </div>
            <div id="profile-section-convictions" class="profile-section">
                ${renderConvictionsList(profile.convictions)}
            </div>
            <div id="profile-section-files" class="profile-section">
                ${renderFilesList(profile.files)}
                <button class="western-button" onclick="addCitizenFile(${citizen.id})">Add File</button>
            </div>
            <div id="profile-section-notes" class="profile-section">
                <textarea class="western-textarea" rows="10">${citizen.notes || ''}</textarea>
                <button class="western-button" onclick="saveCitizenNotes(${citizen.id})">Save Notes</button>
            </div>
        </div>
    `, 'large');
    
    currentProfile = profile;
}

function showProfileSection(section) {
    document.querySelectorAll('.profile-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.profile-section').forEach(s => s.classList.remove('active'));
    
    event.target.classList.add('active');
    document.getElementById(`profile-section-${section}`).classList.add('active');
}

// ============================================================================
// REPORTS TAB
// ============================================================================

function loadReportsTab() {
    const content = document.getElementById('reports-tab');
    if (!content) return;
    
    content.innerHTML = `
        <div class="parchment-panel">
            <h3 class="panel-title">Reports</h3>
            
            <div class="toolbar">
                <button onclick="createNewReport()" class="western-button primary">New Report</button>
                <div class="filter-group">
                    <label>Type:</label>
                    <select id="report-type-filter" class="western-select">
                        <option value="">All Types</option>
                        <option value="arrest">Arrest</option>
                        <option value="citation">Citation</option>
                        <option value="incident">Incident</option>
                    </select>
                    <button onclick="filterReports()" class="western-button">Filter</button>
                </div>
            </div>
            
            <div id="reports-list" class="reports-container">
                <p class="placeholder-text">Loading reports...</p>
            </div>
        </div>
    `;
    
    // Load reports
    fetch(`https://${getResourceName()}/getReports`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({})
    });
}

function displayReportList(reports) {
    const container = document.getElementById('reports-list');
    if (!container) return;
    
    if (reports.length === 0) {
        container.innerHTML = '<p class="placeholder-text">No reports found</p>';
        return;
    }
    
    let html = '<div class="report-list">';
    reports.forEach(report => {
        const date = new Date(report.created_at).toLocaleString();
        html += `
            <div class="report-card">
                <div class="report-header">
                    <h4>${report.title || 'Untitled Report'}</h4>
                    <span class="report-type-badge ${report.report_type}">${report.report_type}</span>
                </div>
                <div class="report-info">
                    <p><strong>Officer:</strong> ${report.officer_name}</p>
                    <p><strong>Subject:</strong> ${report.citizen_name}</p>
                    <p><strong>Location:</strong> ${report.location || 'Not specified'}</p>
                    <p><strong>Date:</strong> ${date}</p>
                </div>
                <div class="report-actions">
                    <button class="western-button small" onclick="viewReport(${report.id})">View</button>
                    <button class="western-button small" onclick="editReport(${report.id})">Edit</button>
                    <button class="western-button small danger" onclick="deleteReport(${report.id})">Delete</button>
                </div>
            </div>
        `;
    });
    html += '</div>';
    
    container.innerHTML = html;
    allReports = reports;
}

function createNewReport() {
    const modal = createModal('Create New Report', `
        <form id="report-form" class="western-form">
            <div class="form-group">
                <label>Report Type:</label>
                <select name="reportType" class="western-select" required>
                    <option value="incident">Incident Report</option>
                    <option value="arrest">Arrest Report</option>
                    <option value="citation">Citation</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Citizen ID:</label>
                <input type="text" name="citizenId" class="western-input" required>
            </div>
            
            <div class="form-group">
                <label>Title:</label>
                <input type="text" name="title" class="western-input" required>
            </div>
            
            <div class="form-group">
                <label>Location:</label>
                <input type="text" name="location" class="western-input">
            </div>
            
            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" class="western-textarea" rows="6" required></textarea>
            </div>
            
            <div class="form-group">
                <label>Charges (one per line):</label>
                <textarea name="charges" class="western-textarea" rows="4"></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="western-button primary">Create Report</button>
                <button type="button" class="western-button" onclick="closeModal()">Cancel</button>
            </div>
        </form>
    `);
    
    document.getElementById('report-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const charges = formData.get('charges').split('\n').filter(c => c.trim());
        
        fetch(`https://${getResourceName()}/createReport`, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                reportType: formData.get('reportType'),
                citizenId: parseInt(formData.get('citizenId')),
                title: formData.get('title'),
                location: formData.get('location'),
                description: formData.get('description'),
                charges: charges
            })
        });
        
        closeModal();
    });
}

// ============================================================================
// WANTED TAB
// ============================================================================

function loadWantedTab() {
    const content = document.getElementById('wanted-tab');
    if (!content) return;
    
    content.innerHTML = `
        <div class="parchment-panel">
            <h3 class="panel-title">Wanted Posters</h3>
            
            <div class="toolbar">
                <button onclick="createNewWantedPoster()" class="western-button primary">New Wanted Poster</button>
                <div class="filter-group">
                    <label>Status:</label>
                    <select id="poster-status-filter" class="western-select">
                        <option value="active">Active</option>
                        <option value="captured">Captured</option>
                        <option value="all">All</option>
                    </select>
                    <button onclick="filterPosters()" class="western-button">Filter</button>
                </div>
            </div>
            
            <div id="wanted-posters-grid" class="posters-grid">
                <p class="placeholder-text">Loading wanted posters...</p>
            </div>
        </div>
    `;
    
    // Load posters
    fetch(`https://${getResourceName()}/getWantedPosters`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({status: 'active'})
    });
}

function displayWantedPosters(posters) {
    const container = document.getElementById('wanted-posters-grid');
    if (!container) return;
    
    if (posters.length === 0) {
        container.innerHTML = '<p class="placeholder-text">No wanted posters found</p>';
        return;
    }
    
    let html = '';
    posters.forEach(poster => {
        const dangerClass = poster.danger_level || 'medium';
        html += `
            <div class="wanted-poster ${dangerClass}">
                <div class="poster-header">
                    <h2>WANTED</h2>
                    <div class="danger-badge ${dangerClass}">${poster.danger_level.toUpperCase()}</div>
                </div>
                <div class="poster-mugshot">
                    ${poster.mugshot ? `<img src="${poster.mugshot}" alt="Suspect">` : '<div class="no-photo-poster">No Photo</div>'}
                </div>
                <div class="poster-info">
                    <h3>${poster.citizen_name}</h3>
                    <p class="poster-number">${poster.poster_number}</p>
                    <p class="poster-charges">${poster.title}</p>
                    <p class="poster-reward">REWARD: $${poster.reward_amount}</p>
                    ${poster.last_known_location ? `<p class="poster-location">Last Seen: ${poster.last_known_location}</p>` : ''}
                </div>
                <div class="poster-actions">
                    <button class="western-button small" onclick="viewPoster(${poster.id})">Details</button>
                    ${poster.status === 'active' ? `<button class="western-button small success" onclick="markCaptured(${poster.id})">Captured</button>` : ''}
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
    allPosters = posters;
}

function createNewWantedPoster() {
    const modal = createModal('Create Wanted Poster', `
        <form id="poster-form" class="western-form">
            <div class="form-group">
                <label>Citizen ID:</label>
                <input type="text" name="citizenId" class="western-input" required>
            </div>
            
            <div class="form-group">
                <label>Title:</label>
                <input type="text" name="title" class="western-input" required placeholder="e.g., Armed Robbery - Multiple Counts">
            </div>
            
            <div class="form-group">
                <label>Danger Level:</label>
                <select name="dangerLevel" class="western-select" required>
                    <option value="low">Low</option>
                    <option value="medium" selected>Medium</option>
                    <option value="high">High</option>
                    <option value="extreme">Extreme</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Reward Amount ($):</label>
                <input type="number" name="rewardAmount" class="western-input" min="0" value="0">
            </div>
            
            <div class="form-group">
                <label>Charges (one per line):</label>
                <textarea name="charges" class="western-textarea" rows="4" required></textarea>
            </div>
            
            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" class="western-textarea" rows="4"></textarea>
            </div>
            
            <div class="form-group">
                <label>Last Known Location:</label>
                <input type="text" name="lastKnownLocation" class="western-input">
            </div>
            
            <div class="form-group">
                <label>Physical Description:</label>
                <textarea name="physicalDescription" class="western-textarea" rows="3"></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="western-button primary">Create Poster</button>
                <button type="button" class="western-button" onclick="closeModal()">Cancel</button>
            </div>
        </form>
    `);
    
    document.getElementById('poster-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const charges = formData.get('charges').split('\n').filter(c => c.trim());
        
        fetch(`https://${getResourceName()}/createWantedPoster`, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                citizenId: parseInt(formData.get('citizenId')),
                title: formData.get('title'),
                dangerLevel: formData.get('dangerLevel'),
                rewardAmount: parseInt(formData.get('rewardAmount')),
                charges: charges,
                description: formData.get('description'),
                lastKnownLocation: formData.get('lastKnownLocation'),
                physicalDescription: formData.get('physicalDescription')
            })
        });
        
        closeModal();
    });
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

function renderReportsList(reports) {
    if (reports.length === 0) return '<p class="placeholder-text">No reports found</p>';
    
    let html = '<div class="simple-list">';
    reports.forEach(report => {
        const date = new Date(report.created_at).toLocaleString();
        html += `
            <div class="list-item">
                <strong>${report.title || 'Untitled'}</strong>
                <span class="badge">${report.report_type}</span>
                <span class="date">${date}</span>
            </div>
        `;
    });
    html += '</div>';
    return html;
}

function renderArrestsList(arrests) {
    if (arrests.length === 0) return '<p class="placeholder-text">No arrests found</p>';
    
    let html = '<div class="simple-list">';
    arrests.forEach(arrest => {
        const date = new Date(arrest.arrest_date).toLocaleString();
        html += `
            <div class="list-item">
                <strong>Arrest - ${arrest.officer_name}</strong>
                <span class="badge">${arrest.conviction_status}</span>
                <span class="date">${date}</span>
                <p class="small">${arrest.location || 'Location not specified'}</p>
            </div>
        `;
    });
    html += '</div>';
    return html;
}

function renderWarrantsList(warrants) {
    if (warrants.length === 0) return '<p class="placeholder-text">No warrants found</p>';
    
    let html = '<div class="simple-list">';
    warrants.forEach(warrant => {
        const date = new Date(warrant.issued_at).toLocaleString();
        html += `
            <div class="list-item">
                <strong>${warrant.warrant_type.toUpperCase()} Warrant</strong>
                <span class="badge ${warrant.status}">${warrant.status}</span>
                <span class="date">${date}</span>
                ${warrant.bail_amount > 0 ? `<p class="small">Bail: $${warrant.bail_amount}</p>` : ''}
            </div>
        `;
    });
    html += '</div>';
    return html;
}

function renderConvictionsList(convictions) {
    if (convictions.length === 0) return '<p class="placeholder-text">No convictions found</p>';
    
    let html = '<div class="simple-list">';
    convictions.forEach(conviction => {
        const date = new Date(conviction.conviction_date).toLocaleString();
        html += `
            <div class="list-item">
                <strong>Conviction</strong>
                <span class="date">${date}</span>
                <p class="small">Fine: $${conviction.fine_amount || 0} | Jail: ${conviction.jail_time || 0} months</p>
            </div>
        `;
    });
    html += '</div>';
    return html;
}

function renderFilesList(files) {
    if (files.length === 0) return '<p class="placeholder-text">No files attached</p>';
    
    let html = '<div class="simple-list">';
    files.forEach(file => {
        const date = new Date(file.uploaded_at).toLocaleString();
        html += `
            <div class="list-item">
                <strong>${file.title}</strong>
                <span class="badge">${file.file_type}</span>
                <span class="date">${date}</span>
                <button class="icon-button" onclick="deleteFile(${file.id})">🗑️</button>
            </div>
        `;
    });
    html += '</div>';
    return html;
}

// ============================================================================
// MODAL SYSTEM
// ============================================================================

function createModal(title, content, size = 'medium') {
    const existingModal = document.getElementById('modal-overlay');
    if (existingModal) {
        existingModal.remove();
    }
    
    const modal = document.createElement('div');
    modal.id = 'modal-overlay';
    modal.className = 'modal-overlay';
    modal.innerHTML = `
        <div class="modal-content ${size}">
            <div class="modal-header">
                <h2>${title}</h2>
                <button class="close-button" onclick="closeModal()">✕</button>
            </div>
            <div class="modal-body">
                ${content}
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    return modal;
}

function closeModal() {
    const modal = document.getElementById('modal-overlay');
    if (modal) {
        modal.remove();
    }
}

// ============================================================================
// NOTIFICATIONS
// ============================================================================

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

function getResourceName() {
    if (window.GetParentResourceName) {
        return window.getResourceName();
    }
    // Fallback for development/testing
    return 'lxr-police';
}

// ============================================================================
// MISSING MODAL FUNCTIONS
// ============================================================================

function showCreateCitizenModal() {
    const content = `
        <h3>Create New Citizen Record</h3>
        <form id="create-citizen-form" class="western-form">
            <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name" class="western-input" required>
            </div>
            <div class="form-group">
                <label>Identifier (e.g., license):</label>
                <input type="text" name="identifier" class="western-input" required>
            </div>
            <div class="form-group">
                <label>Date of Birth:</label>
                <input type="date" name="dob" class="western-input" required>
            </div>
            <div class="form-group">
                <label>Gender:</label>
                <select name="gender" class="western-select">
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                </select>
            </div>
            <div class="form-group">
                <label>Address:</label>
                <textarea name="address" class="western-textarea"></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="western-button">Create Record</button>
                <button type="button" onclick="closeModal()" class="western-button secondary">Cancel</button>
            </div>
        </form>
    `;
    
    createModal('New Citizen Record', content);
    
    document.getElementById('create-citizen-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        
        sendToServer('createCitizen', data);
        closeModal();
        showNotification('Citizen record created', 'success');
    });
}

function showCreateReportModal() {
    const content = `
        <h3>Create Incident Report</h3>
        <form id="create-report-form" class="western-form">
            <div class="form-group">
                <label>Report Type:</label>
                <select name="report_type" class="western-select" required>
                    <option value="incident">Incident Report</option>
                    <option value="arrest">Arrest Report</option>
                    <option value="citation">Citation</option>
                </select>
            </div>
            <div class="form-group">
                <label>Citizen ID (if applicable):</label>
                <input type="number" name="citizen_id" class="western-input">
            </div>
            <div class="form-group">
                <label>Title:</label>
                <input type="text" name="title" class="western-input" required maxlength="255">
            </div>
            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" class="western-textarea" required maxlength="5000"></textarea>
            </div>
            <div class="form-group">
                <label>Location:</label>
                <input type="text" name="location" class="western-input">
            </div>
            <div class="form-actions">
                <button type="submit" class="western-button">Create Report</button>
                <button type="button" onclick="closeModal()" class="western-button secondary">Cancel</button>
            </div>
        </form>
    `;
    
    createModal('New Report', content, 'large');
    
    document.getElementById('create-report-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        
        sendToServer('createReport', data);
        closeModal();
        showNotification('Report created successfully', 'success');
    });
}

function showCreateWantedModal() {
    const content = `
        <h3>Create Wanted Poster</h3>
        <form id="create-wanted-form" class="western-form">
            <div class="form-group">
                <label>Citizen ID:</label>
                <input type="number" name="citizen_id" class="western-input" required>
            </div>
            <div class="form-group">
                <label>Bounty Amount ($):</label>
                <input type="number" name="bounty" class="western-input" required min="0">
            </div>
            <div class="form-group">
                <label>Danger Level:</label>
                <select name="danger_level" class="western-select">
                    <option value="low">Low</option>
                    <option value="medium">Medium</option>
                    <option value="high">High</option>
                    <option value="extreme">Extreme</option>
                </select>
            </div>
            <div class="form-group">
                <label>Crimes:</label>
                <textarea name="crimes" class="western-textarea" required></textarea>
            </div>
            <div class="form-group">
                <label>Last Known Location:</label>
                <input type="text" name="last_location" class="western-input">
            </div>
            <div class="form-group">
                <label>Notes:</label>
                <textarea name="notes" class="western-textarea"></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="western-button">Create Poster</button>
                <button type="button" onclick="closeModal()" class="western-button secondary">Cancel</button>
            </div>
        </form>
    `;
    
    createModal('New Wanted Poster', content, 'large');
    
    document.getElementById('create-wanted-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        
        sendToServer('createWantedPoster', data);
        closeModal();
        showNotification('Wanted poster created', 'success');
    });
}

function showCreateCaseModal() {
    const content = `
        <h3>Create New Case</h3>
        <form id="create-case-form" class="western-form">
            <div class="form-group">
                <label>Case Title:</label>
                <input type="text" name="title" class="western-input" required maxlength="255">
            </div>
            <div class="form-group">
                <label>Case Type:</label>
                <select name="case_type" class="western-select">
                    <option value="investigation">Investigation</option>
                    <option value="robbery">Robbery</option>
                    <option value="murder">Murder</option>
                    <option value="theft">Theft</option>
                    <option value="assault">Assault</option>
                    <option value="other">Other</option>
                </select>
            </div>
            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" class="western-textarea" required></textarea>
            </div>
            <div class="form-group">
                <label>Priority:</label>
                <select name="priority" class="western-select">
                    <option value="low">Low</option>
                    <option value="medium">Medium</option>
                    <option value="high">High</option>
                    <option value="urgent">Urgent</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="western-button">Create Case</button>
                <button type="button" onclick="closeModal()" class="western-button secondary">Cancel</button>
            </div>
        </form>
    `;
    
    createModal('New Case File', content);
    
    document.getElementById('create-case-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        
        sendToServer('createCase', data);
        closeModal();
        showNotification('Case file created', 'success');
    });
}

function showCreateBOLOModal() {
    const content = `
        <h3>Send Telegraph BOLO</h3>
        <form id="create-bolo-form" class="western-form">
            <div class="form-group">
                <label>BOLO Type:</label>
                <select name="bolo_type" class="western-select" required>
                    <option value="person">Person</option>
                    <option value="vehicle">Horse/Wagon</option>
                    <option value="item">Item/Evidence</option>
                </select>
            </div>
            <div class="form-group">
                <label>Subject:</label>
                <input type="text" name="subject" class="western-input" required>
            </div>
            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" class="western-textarea" required></textarea>
            </div>
            <div class="form-group">
                <label>Danger Level:</label>
                <select name="danger_level" class="western-select">
                    <option value="low">Low</option>
                    <option value="medium">Medium</option>
                    <option value="high">High</option>
                    <option value="extreme">Extreme</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="western-button">Send BOLO</button>
                <button type="button" onclick="closeModal()" class="western-button secondary">Cancel</button>
            </div>
        </form>
    `;
    
    createModal('Telegraph BOLO Alert', content);
    
    document.getElementById('create-bolo-form').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);
        
        sendToServer('createBOLO', data);
        closeModal();
        showNotification('BOLO sent to all stations', 'success');
    });
}

// ============================================================================
// FILTER FUNCTIONS
// ============================================================================

function filterWanted() {
    const filter = document.getElementById('wanted-filter').value;
    const filtered = filter === 'all' ? allPosters : allPosters.filter(p => p.status === filter);
    displayWantedPosters(filtered);
}

function filterReports() {
    const filter = document.getElementById('report-type-filter').value;
    const filtered = filter === 'all' ? allReports : allReports.filter(r => r.report_type === filter);
    displayReportList(filtered);
}

function filterCases() {
    const filter = document.getElementById('case-status-filter').value;
    // Request filtered cases from server
    sendToServer('getCases', { status: filter });
}

function filterBOLOs() {
    const filter = document.getElementById('bolo-type-filter').value;
    sendToServer('getBOLOs', { type: filter });
}

// ============================================================================
// DISPLAY FUNCTIONS FOR NEW TABS
// ============================================================================

function displayBOLOList(bolos) {
    const container = document.getElementById('bolo-list');
    if (!bolos || bolos.length === 0) {
        container.innerHTML = '<p class="no-data">No active BOLOs</p>';
        return;
    }
    
    let html = '<div class="bolo-grid">';
    bolos.forEach(bolo => {
        const dangerClass = bolo.danger_level || 'medium';
        html += `
            <div class="bolo-card ${dangerClass}">
                <div class="bolo-header">
                    <span class="bolo-type">${bolo.bolo_type.toUpperCase()}</span>
                    <span class="bolo-danger ${dangerClass}">${bolo.danger_level}</span>
                </div>
                <h4>${bolo.subject}</h4>
                <p>${bolo.description}</p>
                <div class="bolo-meta">
                    <small>Issued: ${new Date(bolo.created_at).toLocaleString()}</small>
                    <small>By: ${bolo.officer_name}</small>
                </div>
                ${bolo.status === 'active' ? `
                    <button onclick="resolveBOLO(${bolo.id})" class="western-button small">Resolve</button>
                ` : ''}
            </div>
        `;
    });
    html += '</div>';
    container.innerHTML = html;
}

function displayCasesList(cases) {
    const container = document.getElementById('cases-list');
    if (!cases || cases.length === 0) {
        container.innerHTML = '<p class="no-data">No case files found</p>';
        return;
    }
    
    let html = '<div class="cases-grid">';
    cases.forEach(caseFile => {
        const priorityClass = caseFile.priority || 'medium';
        const statusClass = caseFile.status || 'open';
        html += `
            <div class="case-card ${statusClass}">
                <div class="case-header">
                    <h4>${caseFile.title}</h4>
                    <span class="case-priority ${priorityClass}">${caseFile.priority}</span>
                </div>
                <p class="case-type">${caseFile.case_type}</p>
                <p class="case-desc">${caseFile.description.substring(0, 100)}...</p>
                <div class="case-meta">
                    <small>Status: ${caseFile.status}</small>
                    <small>Opened: ${new Date(caseFile.created_at).toLocaleDateString()}</small>
                </div>
                <button onclick="viewCase(${caseFile.id})" class="western-button small">View Details</button>
            </div>
        `;
    });
    html += '</div>';
    container.innerHTML = html;
}

function displayRoster(officers) {
    const container = document.getElementById('roster-list');
    if (!officers || officers.length === 0) {
        container.innerHTML = '<p class="no-data">No officers on duty</p>';
        return;
    }
    
    // Update stats
    const marshals = officers.filter(o => o.rank === 'marshal').length;
    const sheriffs = officers.filter(o => o.rank === 'sheriff').length;
    const deputies = officers.filter(o => o.rank === 'deputy').length;
    const rangers = officers.filter(o => o.rank === 'ranger').length;
    
    document.getElementById('roster-marshals').textContent = marshals;
    document.getElementById('roster-sheriffs').textContent = sheriffs;
    document.getElementById('roster-deputies').textContent = deputies;
    document.getElementById('roster-rangers').textContent = rangers;
    
    // Display officer list
    let html = '<div class="roster-grid">';
    officers.forEach(officer => {
        const rankIcon = getRankIcon(officer.rank);
        html += `
            <div class="officer-card">
                <div class="officer-rank">${rankIcon} ${officer.rank.toUpperCase()}</div>
                <h4>${officer.name}</h4>
                <p>Badge: ${officer.badge_number}</p>
                <p>Station: ${officer.station}</p>
                <div class="officer-status ${officer.status}">${officer.status}</div>
            </div>
        `;
    });
    html += '</div>';
    container.innerHTML = html;
}

function getRankIcon(rank) {
    const icons = {
        'marshal': '⭐',
        'sheriff': '⚜️',
        'deputy': '✦',
        'ranger': '⚔️'
    };
    return icons[rank] || '★';
}

// ============================================================================
// SERVER COMMUNICATION HELPERS
// ============================================================================

function sendToServer(eventName, data) {
    const resourceName = getResourceName();
    fetch(`https://${resourceName}/${eventName}`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(data)
    }).catch(err => console.error('Server communication error:', err));
}

function resolveBOLO(boloId) {
    sendToServer('resolveBOLO', { bolo_id: boloId });
    showNotification('BOLO marked as resolved', 'success');
    // Reload BOLOs
    sendToServer('getBOLOs', {});
}

function viewCase(caseId) {
    sendToServer('getCase', { case_id: caseId });
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('MDT System initialized - All features ready');
    
    // Setup Enter key for search
    const searchInput = document.getElementById('citizen-search');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchCitizens();
            }
        });
    }
});
