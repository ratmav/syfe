#!/usr/bin/env python3
"""
Example Python file to demonstrate syntax highlighting and folding
"""

import os
import sys
import json
import logging
from typing import Dict, List, Optional, Union, Any
from dataclasses import dataclass
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


@dataclass
class Config:
    """Configuration class for the application"""
    debug: bool = False
    port: int = 8080
    host: str = "localhost"
    log_level: str = "INFO"
    data_path: Optional[str] = None
    max_connections: int = 100
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert config to dictionary"""
        return {
            "debug": self.debug,
            "port": self.port,
            "host": self.host,
            "log_level": self.log_level,
            "data_path": self.data_path,
            "max_connections": self.max_connections
        }


class DataProcessor:
    """Process data from various sources"""
    
    def __init__(self, config: Config):
        self.config = config
        self.data: List[Dict[str, Any]] = []
        logger.info("Initialized DataProcessor with config: %s", config.to_dict())
    
    def load_data(self, filename: str) -> bool:
        """
        Load data from JSON file
        
        Args:
            filename: Path to the JSON file
            
        Returns:
            True if data was loaded successfully, False otherwise
        """
        try:
            # Demonstrate indentation-based folding with nested blocks
            if os.path.exists(filename):
                with open(filename, 'r') as f:
                    content = f.read()
                    if content:
                        self.data = json.loads(content)
                        logger.info(f"Loaded {len(self.data)} records from {filename}")
                        
                        # Process the data
                        for item in self.data:
                            if "timestamp" in item:
                                try:
                                    # Convert timestamp strings to datetime objects
                                    item["timestamp"] = datetime.fromisoformat(item["timestamp"])
                                except ValueError:
                                    logger.warning(f"Invalid timestamp format in record: {item}")
                        
                        return True
                    else:
                        logger.warning(f"File {filename} is empty")
            else:
                logger.error(f"File {filename} does not exist")
        except Exception as e:
            logger.exception(f"Error loading data: {e}")
        
        return False
    
    def process(self) -> Optional[Dict[str, Any]]:
        """Process the loaded data and return statistics"""
        if not self.data:
            logger.warning("No data to process")
            return None
        
        result = {
            "count": len(self.data),
            "timestamp": datetime.now().isoformat()
        }
        
        return result


def main():
    """Main function"""
    # Parse command line arguments
    import argparse
    parser = argparse.ArgumentParser(description="Data Processor Example")
    parser.add_argument("--config", help="Path to config file")
    parser.add_argument("--debug", action="store_true", help="Enable debug mode")
    args = parser.parse_args()
    
    # Initialize configuration
    config = Config(debug=args.debug)
    
    # Create processor and run
    processor = DataProcessor(config)
    if args.config:
        if processor.load_data(args.config):
            result = processor.process()
            print(json.dumps(result, indent=2, default=str))
            return 0
        else:
            return 1
    else:
        logger.error("No config file specified")
        return 1


if __name__ == "__main__":
    sys.exit(main())