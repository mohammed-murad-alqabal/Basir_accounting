#!/usr/bin/env python3
"""
Figma API Helper for Kiro Integration
المؤلف: فريق وكلاء تطوير مشروع بصير
"""

import os
import sys
import json
import requests
from typing import Dict, List, Optional

class FigmaAPI:
    """Helper class for Figma API interactions"""
    
    def __init__(self, token: str):
        self.token = token
        self.base_url = "https://api.figma.com/v1"
        self.headers = {
            "X-Figma-Token": token,
            "Content-Type": "application/json"
        }
    
    def get_me(self) -> Dict:
        """Get current user information"""
        response = requests.get(f"{self.base_url}/me", headers=self.headers)
        return self._handle_response(response)
    
    def get_teams(self) -> Dict:
        """Get user's teams"""
        response = requests.get(f"{self.base_url}/teams", headers=self.headers)
        return self._handle_response(response)
    
    def get_team_projects(self, team_id: str) -> Dict:
        """Get projects for a specific team"""
        response = requests.get(
            f"{self.base_url}/teams/{team_id}/projects", 
            headers=self.headers
        )
        return self._handle_response(response)
    
    def get_project_files(self, project_id: str) -> Dict:
        """Get files in a specific project"""
        response = requests.get(
            f"{self.base_url}/projects/{project_id}/files",
            headers=self.headers
        )
        return self._handle_response(response)
    
    def get_file(self, file_key: str, **params) -> Dict:
        """Get file information"""
        response = requests.get(
            f"{self.base_url}/files/{file_key}",
            headers=self.headers,
            params=params
        )
        return self._handle_response(response)
    
    def get_file_nodes(self, file_key: str, node_ids: List[str], **params) -> Dict:
        """Get specific nodes from a file"""
        params['ids'] = ','.join(node_ids)
        response = requests.get(
            f"{self.base_url}/files/{file_key}/nodes",
            headers=self.headers,
            params=params
        )
        return self._handle_response(response)
    
    def get_comments(self, file_key: str) -> Dict:
        """Get comments for a file"""
        response = requests.get(
            f"{self.base_url}/files/{file_key}/comments",
            headers=self.headers
        )
        return self._handle_response(response)
    
    def _handle_response(self, response: requests.Response) -> Dict:
        """Handle API response"""
        if response.status_code == 200:
            return response.json()
        else:
            error_data = {
                "error": True,
                "status_code": response.status_code,
                "message": response.text
            }
            if response.status_code == 401:
                error_data["message"] = "Invalid or expired Figma token"
            elif response.status_code == 403:
                error_data["message"] = "Access denied - check permissions"
            elif response.status_code == 404:
                error_data["message"] = "Resource not found"
            
            return error_data

def main():
    """CLI interface for Figma API"""
    if len(sys.argv) < 2:
        print("Usage: python figma_api.py <command> [args...]")
        print("Commands:")
        print("  me                    - Get user info")
        print("  teams                 - Get user teams")
        print("  team-projects <id>    - Get team projects")
        print("  project-files <id>    - Get project files")
        print("  file <key>            - Get file info")
        print("  comments <key>        - Get file comments")
        return
    
    # Get token from environment
    token = <credential-fixture>'FIGMA_ACCESS_TOKEN')
    if not token:
        print("❌ FIGMA_ACCESS_TOKEN not found in environment")
        print("Please set it in your .env file")
        return
    
    api = <credential-fixture>(token)
    command = sys.argv[1]
    
    try:
        if command == "me":
            result = api.get_me()
        elif command == "teams":
            result = api.get_teams()
        elif command == "team-projects" and len(sys.argv) > 2:
            result = api.get_team_projects(sys.argv[2])
        elif command == "project-files" and len(sys.argv) > 2:
            result = api.get_project_files(sys.argv[2])
        elif command == "file" and len(sys.argv) > 2:
            result = api.get_file(sys.argv[2])
        elif command == "comments" and len(sys.argv) > 2:
            result = api.get_comments(sys.argv[2])
        else:
            print(f"❌ Unknown command: {command}")
            return
        
        print(json.dumps(result, indent=2, ensure_ascii=False))
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    main()